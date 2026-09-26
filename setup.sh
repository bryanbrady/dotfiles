#!/usr/bin/env bash
# Install CLI tools. macOS: Homebrew. Linux (Debian/Ubuntu): apt, falling back
# to upstream releases for anything apt doesn't carry.
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
export PATH="$BIN_DIR:$PATH"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

install_claude() {
    if have claude; then
        log "claude already installed"
    else
        log "Installing claude"
        curl -fsSL https://claude.ai/install.sh | bash
    fi
}

### macOS ####################################################################

setup_macos() {
    if ! have brew; then
        log "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    log "Installing packages with brew"
    brew install \
        ast-grep bat cloc git-delta difftastic eza fd fzf gh git git-lfs glab \
        htop jq numbat ripgrep tmux tree uv qsv yq zoxide
}

### Linux ####################################################################

TMP_DIR=""

# Succeeds if apt has an installable candidate for the package.
apt_has() {
    local candidate
    candidate="$(apt-cache policy "$1" 2>/dev/null | awk '/Candidate:/ {print $2}')"
    [[ -n "$candidate" && "$candidate" != "(none)" ]]
}

# Print the download URL of the latest GitHub release asset matching a regex.
github_asset_url() {
    local repo="$1" regex="$2" auth=()
    [[ -n "${GITHUB_TOKEN:-}" ]] && auth=(-H "Authorization: Bearer $GITHUB_TOKEN")
    curl -fsSL ${auth[@]+"${auth[@]}"} "https://api.github.com/repos/$repo/releases/latest" \
        | jq -r --arg re "$regex" '.assets[].browser_download_url | select(test($re; "i"))' \
        | head -n1
}

download() {
    local url="$1" out
    [[ -n "$url" ]] || { echo "error: no matching release asset" >&2; return 1; }
    out="$TMP_DIR/$(basename "$url")"
    curl -fsSL -o "$out" "$url"
    echo "$out"
}

install_deb_url() {
    local deb
    deb="$(download "$1")"
    sudo apt-get install -y "$deb"
}

# Install a single binary from a raw file, .tar.gz, or .zip URL into BIN_DIR.
install_bin_url() {
    local url="$1" name="$2" file dir bin
    file="$(download "$url")"
    dir="$TMP_DIR/$name.d"
    mkdir -p "$dir"
    case "$file" in
        *.tar.gz | *.tgz) tar -xzf "$file" -C "$dir" ;;
        *.zip) unzip -q -o "$file" -d "$dir" ;;
        *) cp "$file" "$dir/$name" ;;
    esac
    bin="$(find "$dir" -type f -name "$name" | head -n1)"
    [[ -n "$bin" ]] || { echo "error: $name not found in $url" >&2; return 1; }
    install -m 755 "$bin" "$BIN_DIR/$name"
}

# Install from apt if available, otherwise run the given fallback function.
apt_or() {
    local pkg="$1" cmd="$2" fallback="$3"
    if have "$cmd"; then
        log "$cmd already installed"
    elif apt_has "$pkg"; then
        log "Installing $pkg (apt)"
        sudo apt-get install -y "$pkg"
    else
        log "Installing $cmd (upstream release)"
        "$fallback"
    fi
}

fallback_delta() { install_deb_url "$(github_asset_url dandavison/delta "/git-delta_[^/]*_${DEB_ARCH}\\.deb$")"; }
fallback_difftastic() { install_bin_url "$(github_asset_url Wilfred/difftastic "/difft-([^/]*-)?${ARCH}-unknown-linux-gnu\\.tar\\.gz$")" difft; }
fallback_eza() { install_bin_url "$(github_asset_url eza-community/eza "/eza_${ARCH}-unknown-linux-gnu\\.tar\\.gz$")" eza; }
fallback_fzf() { install_bin_url "$(github_asset_url junegunn/fzf "/fzf-[^/]*-linux_${DEB_ARCH}\\.tar\\.gz$")" fzf; }
fallback_numbat() { install_deb_url "$(github_asset_url sharkdp/numbat "/numbat_[^/]*_${DEB_ARCH}\\.deb$")"; }
fallback_zoxide() { curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh; }
fallback_glab() {
    local url
    url="$(curl -fsSL "https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases/permalink/latest" \
        | jq -r --arg re "_linux_(${DEB_ARCH}|${ARCH})\\.deb$" \
            '.assets.links[] | (.direct_asset_url // .url) | select(test($re; "i"))' \
        | head -n1)"
    install_deb_url "$url"
}

setup_linux() {
    have apt-get || { echo "error: apt-get not found; only Debian/Ubuntu is supported" >&2; exit 1; }

    TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TMP_DIR"' EXIT

    ARCH="$(uname -m)"                   # x86_64 / aarch64
    DEB_ARCH="$(dpkg --print-architecture)" # amd64 / arm64

    log "Installing packages with apt"
    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates curl unzip \
        bat cloc fd-find gh git git-lfs htop jq ripgrep tmux tree

    # Debian/Ubuntu rename these binaries to avoid name clashes.
    have bat || { have batcat && ln -sf "$(command -v batcat)" "$BIN_DIR/bat"; }
    have fd || { have fdfind && ln -sf "$(command -v fdfind)" "$BIN_DIR/fd"; }

    # Only in apt on newer releases.
    apt_or git-delta delta fallback_delta
    apt_or difftastic difft fallback_difftastic
    apt_or eza eza fallback_eza
    apt_or glab glab fallback_glab
    apt_or numbat numbat fallback_numbat
    apt_or zoxide zoxide fallback_zoxide

    # apt's fzf is too old on Ubuntu 24.04 (no --bash, added in 0.48).
    if have fzf && fzf --bash >/dev/null 2>&1; then
        log "fzf already installed"
    else
        log "Installing fzf (upstream release)"
        fallback_fzf
    fi

    # Not in apt (apt's "yq" is a different tool), so always upstream.
    if have uv; then
        log "uv already installed"
    else
        log "Installing uv"
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi

    if have qsv; then
        log "qsv already installed"
    else
        log "Installing qsv"
        install_bin_url "$(github_asset_url dathere/qsv "/qsv-[^/]*-${ARCH}-unknown-linux-gnu\\.zip$")" qsv
    fi

    if have yq; then
        log "yq already installed"
    else
        log "Installing yq"
        install_bin_url "$(github_asset_url mikefarah/yq "/yq_linux_${DEB_ARCH}$")" yq
    fi

    if have ast-grep; then
        log "ast-grep already installed"
    else
        log "Installing ast-grep"
        uv tool install ast-grep-cli
    fi
}

### Main #####################################################################

case "$(uname -s)" in
    Darwin) setup_macos ;;
    Linux) setup_linux ;;
    *) echo "error: unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

install_claude

log "Done. Make sure $BIN_DIR is on your PATH."
