FROM ghcr.io/linuxserver/baseimage-alpine:amd64-3.15 as build-stage

RUN \
  echo "**** install packages ****" && \
  apk add -U --update --no-cache \
    git \
    npm && \
  npm install --global yarn && \
  git clone --shallow-submodules --recurse-submodules https://github.com/DustinBrett/daedalOS.git /daedalos && \
  cd /daedalos && \
  rm -rf /daedalos/yarn.lock && \
  yarn && \
  yarn build:fs

FROM ghcr.io/linuxserver/baseimage-alpine:3.15

ARG BUILD_DATE
ARG VERSION
ARG APP_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="quietsy"

COPY --from=build-stage /daedalos/ /daedalos/
COPY /root/ /

RUN \
  echo "**** install packages ****" && \
  apk add -U --update --no-cache \
    git \
    npm && \
  npm install --global yarn
