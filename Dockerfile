# This is an environment to test the makefile on.
# docker run --volume=/home/matt/dotfiles:/dotfiles:rw -it iflowfor8hours/dotfilestest /bin/bash

FROM alpine:latest
RUN apk update &&\
    apk add make vim nvim zsh bash
RUN mkdir /dotfiles
WORKDIR /dotfiles
