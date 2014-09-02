FROM ubuntu:latest
MAINTAINER Ahmet Alp Balkan <ahmetalpbalkan@gmail.com>

RUN apt-get -qq update

# Install Mono
RUN apt-get -qqy install libtool autoconf g++ gettext make git unzip && \
    git clone -b mono-3.6.0.39 --single-branch --depth 1 https://github.com/mono/mono /tmp/mono && \
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

# Install 'kvm' and latest KRE
# (this step requires apt-get unzip, but it's included in the list above)
RUN touch ~/.bash_profile
RUN curl https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh
RUN /bin/bash -c "source ~/.kre/kvm/kvm.sh && kvm upgrade; echo ExitCode=$?"

# Add symlink to kvm default version
ADD kvm-symlink.sh /tmp/kvm-symlink.sh
RUN /bin/bash /tmp/kvm-symlink.sh
RUN rm /tmp/kvm-symlink.sh
ENV PATH $PATH:/.kre/packages/default/bin
