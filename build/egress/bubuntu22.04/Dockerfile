# Copyright 2023 LiveKit, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM hullovv/livekit-gstreamer-prod

ARG TARGETPLATFORM

WORKDIR /workspace

# install go
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then GOARCH=arm64; else GOARCH=amd64; fi && \
    wget https://go.dev/dl/go1.22.1.linux-${GOARCH}.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go1.22.1.linux-${GOARCH}.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"


# download go modules
COPY go.mod .
COPY go.sum .
RUN go mod download

# copy source
COPY cmd/ cmd/
COPY pkg/ pkg/
COPY version/ version/

# copy templates
COPY --from=livekit/egress-templates workspace/build/ cmd/server/templates/
# delete .map files
RUN find cmd/server/templates/ -name *.map | xargs rm


# RUN apt update && apt-get install -y \
#     libgstreamer-plugins-base1.0-dev \
#     libgstrtspserver-1.0-0 \
#     libgstreamer1.0-0 \
#     libgstreamer-plugins-bad1.0-0 \
#     gstreamer1.0-plugins-good \
#     gstreamer1.0-plugins-bad

# RUN apt remove -y libmpeg2-4 && apt install -y libmpeg2-4

# RUN apt update && apt-get install -y 

# build
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then GOARCH=arm64; else GOARCH=amd64; fi && \
    CGO_ENABLED=1 GOOS=linux GOARCH=${GOARCH} GO111MODULE=on GODEBUG=disablethp=1 go build -a -o egress ./cmd/server

FROM hullovv/livekit-gstreamer-prod

COPY build/egress/bubuntu22.04/install-dependencies /

RUN /install-dependencies && apt remove -y libmpeg2-4 && \
    apt update && apt-get install --reinstall -y --allow-change-held-packages \
    # libgstreamer-plugins-base1.0-dev \
    # libgstrtspserver-1.0-0 \
    # libgstreamer1.0-0 \
    # libgstreamer-plugins-bad1.0-0 \
    # gstreamer1.0-plugins-good \
    # gstreamer1.0-plugins-bad \
    # libgstreamer-plugins-base1.0-dev \
    libmpeg2-4 \
    curl \
    fonts-noto \
    gnupg \
    pulseaudio \
    unzip \
    wget \
    xvfb \
    gstreamer1.0-plugins-base- \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    bubblewrap \
    ca-certificates \
    iso-codes \
    ladspa-sdk \
    liba52-0.7.4 \
    libaa1 \
    libaom3 \
    libass9 \
    libavcodec-dev \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev \
    libbs2b0 \
    libbz2-1.0 \
    libcaca0 \
    libcap2 \
    libchromaprint1 \
    libcurl3-gnutls \
    libdca0 \
    libde265-0 \
    libdv4 \
    libdvdnav4 \
    libdvdread8 \
    libdw1 \
    libegl1 \
    libepoxy0 \
    libfaac0 \
    libfaad2 \
    libfdk-aac2 \
    libflite1 \
    libgbm1 \
    libgcrypt20 \
    libgl1 \
    libgles1 \
    libgles2 \
    libglib2.0-0 \
    libgme0 \
    libgmp10 \
    libgsl27 \
    libgsm1 \
    libgudev-1.0-0 \
    libharfbuzz-icu0 \
    libjpeg8 \
    libkate1 \
    liblcms2-2 \
    liblilv-0-0 \
    libmjpegutils-2.1-0 \
    libmodplug1 \
    libmp3lame0 \
    libmpcdec6 \
    libmpeg2-4 \
    libmpg123-0 \
    libofa0 \
    libogg0 \
    libopencore-amrnb0 \
    libopencore-amrwb0 \
    libopenexr-dev \
    libopenjp2-7 \
    libopus0 \
    liborc-0.4-0 \
    libpango-1.0-0 \
    libpng16-16 \
    librsvg2-2 \
    librtmp1 \
    libsbc1 \
    libseccomp2 \
    libshout3 \
    libsndfile1 \
    libsoundtouch1 \
    libsoup2.4-1 \
    libspandsp2 \
    libspeex1 \
    libsrt-openssl-dev \
    libsrtp2-1 \
    libssl3 \
    libtag1v5 \
    libtheora0 \
    libtwolame0 \
    libunwind8 \
    libvisual-0.4-0 \
    libvo-aacenc0 \
    libvo-amrwbenc0 \
    libvorbis0a \
    libvpx7 \
    libvulkan1 \
    libwavpack1 \
    libwebp7 \
    libwebpdemux2 \
    libwebpmux3 \
    libwebrtc-audio-processing1 \
    libwildmidi2 \
    libwoff1 \
    libx264-dev \
    libx265-dev \
    libxkbcommon0 \
    libxslt1.1 \
    libzbar0 \
    libzvbi0 \
    mjpegtools \
    nvidia-driver-535 \
    xdg-dbus-proxy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG TARGETPLATFORM

# install deps
# install chrome
COPY --from=livekit/chrome-installer:117.0.5874.0 /chrome-installer /chrome-installer
RUN apt update && /chrome-installer/install-chrome "$TARGETPLATFORM"

# clean up
RUN rm -rf /var/lib/apt/lists/*

# create egress user
RUN useradd -ms /bin/bash -g root -G sudo,pulse,pulse-access egress
RUN mkdir -p home/egress/tmp home/egress/.cache/xdgr && \
    chown -R egress /home/egress

# copy files
COPY --from=0 /workspace/egress /bin/
COPY build/egress/bubuntu22.04/entrypoint.sh /
# RUN apt update -y && apt install -y --reinstall -y 

# run
USER egress
ENV PATH=${PATH}:/chrome
ENV XDG_RUNTIME_DIR=/home/egress/.cache/xdgr
ENV CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
ENTRYPOINT ["/entrypoint.sh"]
