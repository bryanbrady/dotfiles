-- Hammerspoon configuration
-- Enable control channels so config can be introspected/automated.
require("hs.ipc")
hs.allowAppleScript(true)

-- ---------------------------------------------------------------------------
-- Window/screen dump
-- Hotkey writes a snapshot of all monitors and all windows to a log file.
-- Use this to discover the app/window/screen identifiers for arranging later.
-- ---------------------------------------------------------------------------
local dumpLogPath = hs.configdir .. "/window-dump.log"

local function dumpWindowsAndScreens()
  local lines = {}
  local function add(s) table.insert(lines, s) end

  add("================================================================")
  add("DUMP " .. os.date("%Y-%m-%d %H:%M:%S"))
  add("================================================================")

  add("")
  add("SCREENS (" .. #hs.screen.allScreens() .. "):")
  local primary = hs.screen.primaryScreen()
  for _, s in ipairs(hs.screen.allScreens()) do
    local f = s:fullFrame()
    add(string.format(
      "  name=%q  id=%d  uuid=%s  frame=(%d,%d %dx%d)  primary=%s",
      s:name(), s:id(), s:getUUID(), f.x, f.y, f.w, f.h, tostring(s == primary)))
  end

  add("")
  add("WINDOWS:")
  for _, w in ipairs(hs.window.allWindows()) do
    local app = w:application()
    local f = w:frame()
    local scr = w:screen()
    add(string.format(
      "  app=%q  bundleID=%s  winID=%d  screen=%q  standard=%s  frame=(%d,%d %dx%d)  title=%q",
      app and app:name() or "?",
      app and app:bundleID() or "?",
      w:id() or -1,
      scr and scr:name() or "?",
      tostring(w:isStandard()),
      f.x, f.y, f.w, f.h,
      (w:title() or "")))
  end
  add("")

  local f = io.open(dumpLogPath, "a")
  if f then
    f:write(table.concat(lines, "\n") .. "\n")
    f:close()
    hs.alert.show("Dumped windows + screens\n" .. dumpLogPath)
  else
    hs.alert.show("ERROR: could not write " .. dumpLogPath)
  end
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "D", dumpWindowsAndScreens)

-- ---------------------------------------------------------------------------
-- Window arranger
-- Hotkey throws each known app's windows onto its assigned monitor and
-- maximizes them (fills the monitor's usable area). Resize/layout comes later.
-- ---------------------------------------------------------------------------

-- Monitors are matched by UUID (stable across reconnect; names are not).
local screens = {
  LAPTOP     = "37D8832A-2D66-02CA-B9F7-8F30A301B230", -- Built-in Retina
  DELL_LEFT  = "D91C163D-4DC0-4F66-AB83-ABE6DBD2A153", -- DELL S2722DC, x=-1753
  DELL_RIGHT = "DEC9C45C-B4D6-4478-B8A1-BD6850151DBA", -- DELL S2722DC, x=807
}

-- bundleID -> placement. `screen` is required; `unit` is an optional
-- {x, y, w, h} rectangle in fractions of the monitor's usable area
-- (origin top-left). Omit `unit` to maximize (full screen).
local layout = {
  ["com.googlecode.iterm2"]      = { screen = "DELL_LEFT" },
  ["com.electron.dockerdesktop"] = { screen = "DELL_LEFT" },
  ["com.tinyspeck.slackmacgap"]  = { screen = "LAPTOP" },
  ["org.vim.MacVim"]             = { screen = "DELL_RIGHT", unit = {0,    0,    0.5, 1  } }, -- left half
  ["com.microsoft.VSCode"]       = { screen = "DELL_RIGHT", unit = {0.1,  0,    0.9, 1  } }, -- right, 90% width
  ["com.google.Chrome"]          = { screen = "DELL_RIGHT", unit = {0.05, 0.05, 0.9, 0.9} }, -- centered, 90%
}

local function arrangeWindows()
  local moved, skipped = 0, 0
  for _, w in ipairs(hs.window.allWindows()) do
    local app = w:application()
    local bid = app and app:bundleID()
    local rule = bid and layout[bid]
    if rule and w:isStandard() and not w:isMinimized() then
      local scr = hs.screen.find(screens[rule.screen])
      if scr then
        local f = scr:frame()                 -- usable area (excludes menubar/Dock)
        local u = rule.unit or {0, 0, 1, 1}    -- default: fill the monitor
        w:setFrame({
          x = f.x + u[1] * f.w,
          y = f.y + u[2] * f.h,
          w = u[3] * f.w,
          h = u[4] * f.h,
        }, 0)                                  -- 0 = no animation
        moved = moved + 1
      else
        skipped = skipped + 1                  -- assigned monitor not connected
      end
    end
  end
  hs.alert.show(string.format("Arranged %d window(s)%s", moved,
    skipped > 0 and (", " .. skipped .. " skipped (monitor off)") or ""))
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "return", arrangeWindows)

hs.alert.show("Hammerspoon config loaded")
