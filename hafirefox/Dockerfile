ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:10.2.0

FROM ${BUILD_FROM}

RUN \
    apk --no-cache add \
      py-pip \
      build-base \
      python3-dev &&\
    pip install --no-cache-dir numpy &&\
    apk del build-base python3-dev

RUN \
    # Install required packages
    echo "http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --update --upgrade --no-cache add \
      git \
      xvfb \
      x11vnc \
      procps \
      && \
    # Install noVNC
    git clone --depth 1 https://github.com/novnc/noVNC.git /root/noVNC && \
    git clone --depth 1 https://github.com/novnc/websockify /root/noVNC/utils/websockify && \
    rm -rf /root/noVNC/.git && \
    rm -rf /root/noVNC/utils/websockify/.git && \
    apk del git 

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl && \
 if [ -z ${FIREFOX_VERSION+x} ]; then \
  arch="${BUILD_ARCH}" \
  && if [ "${BUILD_ARCH}" = "amd64" ]; then arch="x86_64"; fi \
  && if [ "${BUILD_ARCH}" = "i386" ]; then arch="x86"; fi \
	&& FIREFOX_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.14/community/${arch}/APKINDEX.tar.gz" | tar -xz -C /tmp \
	&& awk '/^P:firefox-esr$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
 fi && \
 apk add --no-cache \
	firefox-esr==${FIREFOX_VERSION} \
  # Also install some fonts
  # see: github.com/docker-library/openjdk/issues/73
  ttf-dejavu && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# Setup noVNC
RUN cp /root/noVNC/vnc.html /root/noVNC/index.html
RUN sed -i "/wait ${proxy_pid}/i if [ -n \"\$AUTOCONNECT\" ]; then sed -i \"s/'autoconnect', false/'autoconnect', '\$AUTOCONNECT'/\" /root/noVNC/app/ui.js; fi" /root/noVNC/utils/novnc_proxy
RUN sed -i "/wait ${proxy_pid}/i if [ -n \"\$VNC_PASSWORD\" ]; then sed -i \"s/WebUtil.getConfigVar('password')/'\$VNC_PASSWORD'/\" /root/noVNC/app/ui.js; fi" /root/noVNC/utils/novnc_proxy
RUN sed -i "/wait ${proxy_pid}/i if [ -n \"\$VIEW_ONLY\" ]; then sed -i \"s/UI.rfb.viewOnly = UI.getSetting('view_only');/UI.rfb.viewOnly = \$VIEW_ONLY;/\" /root/noVNC/app/ui.js; fi" /root/noVNC/utils/novnc_proxy

# Setup x11vnc to start always with firefox
RUN echo "exec firefox" > .xinitrc && chmod +x .xinitrc

# Setup environment variables
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768

# Copy root filesystem
COPY rootfs /
VOLUME /config

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Artur Braga" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    # org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Artur Braga" \
    org.opencontainers.image.licenses="GNU General Public License v3.0" \
    # org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}