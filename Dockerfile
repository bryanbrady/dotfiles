FROM ubuntu:bionic

WORKDIR /dotfiles
COPY . .
RUN ./gen.sh > env.sh

