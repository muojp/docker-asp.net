FROM ubuntu:latest
MAINTAINER Ahmet Alp Balkan <ahmetalpbalkan@gmail.com>

RUN apt-get -qq update

# Install Mono
RUN apt-get -qqy install libtool autoconf g++ gettext make git unzip && \
    git clone --depth 1 https://github.com/mono/mono /tmp/mono && \
    cd /tmp/mono && \
    ./autogen.sh --prefix=/usr && \
    make get-monolite-latest && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/mono
RUN mono --version

# Install ASP.NET-specific certificates to machine store.
# Some of these might be redundant in the future.
RUN yes | certmgr -ssl -m https://go.microsoft.com
RUN yes | certmgr -ssl -m https://nugetgallery.blob.core.windows.net
RUN yes | certmgr -ssl -m https://myget.org
RUN yes | certmgr -ssl -m https://nuget.org

# Synchronize trusted root certificates
RUN mozroots --import --sync --quiet
