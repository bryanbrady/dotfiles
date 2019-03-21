FROM ubuntu:bionic

WORKDIR /dotfiles
COPY . .
RUN ./install.sh

