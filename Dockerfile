FROM debian:wheezy
MAINTAINER Ahmet Alp Balkan <ahmetalpbalkan@gmail.com>

RUN apt-get -qq update

# Install Mono
RUN apt-get -qq update && apt-get -qqy install curl unzip
RUN curl -s http://download.mono-project.com/repo/xamarin.gpg | apt-key add -
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list
RUN apt-get -qq update && apt-get -qqy install mono-complete

# Install libuv for Kestrel (from source code. binary provided on jessie is too old)
RUN apt-get -qqy install git autoconf automake build-essential libtool
RUN git clone https://github.com/joyent/libuv.git /usr/local/src/libuv && \
  cd /usr/local/src/libuv && \
  git checkout v1.0.0-rc2 && \
  sh autogen.sh && ./configure && make && make install && \
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
