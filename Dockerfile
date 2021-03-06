FROM debian:wheezy
MAINTAINER Ahmet Alp Balkan <ahmetalpbalkan@gmail.com>

RUN apt-get -qq update

# Install Mono
RUN apt-get -qq update && apt-get -qqy install curl unzip
RUN curl -s http://download.mono-project.com/repo/xamarin.gpg | apt-key add -
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list
RUN apt-get -qq update && apt-get -qqy install mono-complete

# Install libuv for Kestrel (from source code. binary provided on jessie is too old)
RUN apt-get -qqy install autoconf automake build-essential libtool
ENV LIBUV_VERSION 1.0.0-rc2
RUN curl -s https://codeload.github.com/joyent/libuv/tar.gz/v$LIBUV_VERSION | tar zxfv - -C /usr/local/src && \
  cd /usr/local/src/libuv-$LIBUV_VERSION && \
  sh autogen.sh && ./configure && make && make install && \
  rm -rf /usr/local/src/libuv-$LIBUV_VERSION && \
  ldconfig

# Install ASP.NET vNext certificates
RUN yes | certmgr -ssl -m https://go.microsoft.com https://myget.org https://nuget.org
RUN mozroots --import --sync --quiet

# Install ASP.NET vNext and latest KRE
WORKDIR /root
ENV HOME /root
RUN curl -s https://raw.githubusercontent.com/aspnet/Home/dev/kvminstall.sh | sh
RUN bash -c "source ~/.kre/kvm/kvm.sh && kvm upgrade; echo KvmUpgradeExitCode=$?"
RUN ln -s ~/.kre/packages/`bash -c "source ~/.kre/kvm/kvm.sh && kvm alias default"` ~/.kre/packages/default
ENV PATH $PATH:/root/.kre/packages/default/bin
