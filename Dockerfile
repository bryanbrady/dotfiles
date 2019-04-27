FROM alpine

WORKDIR /dotfiles
RUN apk add bash
COPY . .
RUN /dotfiles/install.sh

