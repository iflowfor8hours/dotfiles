# This is an environment to test the makefile on.
# docker run --volume=/home/matt/dotfiles:/dotfiles:rw -it iflowfor8hours/dotfilestest /bin/bash

FROM ubuntu:16.04
RUN apt-get update && apt-get install -y make sudo
RUN mkdir /dotfiles
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
WORKDIR /dotfiles
