FROM --platform=linux/amd64 ubuntu:18.04

RUN apt-get update && \
    apt-get install -y xserver-xorg x11-apps \
    locales

RUN apt-get -y --no-install-recommends install libtcmalloc-minimal4