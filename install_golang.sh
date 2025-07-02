#!/bin/bash
source ~/.profile

GO_VERSION="1.24.2"
GO_PATH=$(which go)
EGRESS_FILES_PATH='/egress_source'
GOARCH=$(dpkg-architecture -q DEB_BUILD_ARCH)
GO_TAR_NAME='go.tar.gz'
EGRESS_PATH=$(which egress)

if [[ $GO_PATH == '' ]]; then
    echo "Install Golang with version $GO_VERSION"
    wget wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -O $GO_TAR_NAME
    tar -xzvf go.tar.gz -C /usr/local
    echo "export PATH=$HOME/go/bin:/usr/local/go/bin:$PATH" >> ~/.profile
    rm $GO_TAR_NAME
    echo "Installing golang done..."
fi

if [[ $1 != '' ]]; then
    echo "Build egress....."
    cd $EGRESS_FILES_PATH
    `go mod tidy`
    CGO_ENABLED=1 GOOS=linux GOARCH=${GOARCH} GO111MODULE=on GODEBUG=disablethp=1 go build -buildvcs=false -a -o egress ./cmd/server
    echo "Change egress bin ......"
    rm $EGRESS_PATH && cp ./egress $EGRESS_PATH
fi