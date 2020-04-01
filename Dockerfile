FROM alpine:3.11

WORKDIR /root

#-- set path
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/google-cloud-sdk/bin:/root/scripts:/root/.plenv/bin/:/root/.plenv/versions/5.24.1/bin
ENV SHELL /bin/bash

#-- packages
RUN apk add --no-cache \
    ca-certificates curl wget g++ make ffmpeg bash git patch \
    openssl-dev openssl libxml2-dev libc-dev libstdc++ expat python jq 

#-- perl
RUN curl -sL http://is.gd/plenvsetup | bash
RUN plenv install 5.24.1
RUN plenv global 5.24.1 && plenv install-cpanm && plenv rehash

#-- perl modules
RUN cpanm -n Plack
RUN cpanm -n Starman
RUN cpanm -n Router::Boom
RUN cpanm -n JSON

#-- APP
COPY app app
WORKDIR /root/app
RUN cpanm -v --installdeps -n ./
RUN perl -wc ./app.psgi

WORKDIR /root/app
EXPOSE 5000

ENTRYPOINT ["/root/.plenv/versions/5.24.1/bin/starman", "/root/app/app.psgi"]