FROM debian:wheezy
MAINTAINER Ahmet Alp Balkan <ahmetalpbalkan@gmail.com>

RUN apt-get -qq update

# Install Mono
RUN apt-get -qq update && apt-get -qqy install curl unzip
RUN curl -s http://download.mono-project.com/repo/xamarin.gpg | apt-key add -
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list
RUN apt-get -qq update && apt-get -qqy install mono-complete

# Install libuv for Kestrel (from source code. binary provided on jessie is too old)
RUN apt-get -qq update && apt-get -qqy install git autoconf automake build-essential libtool
ADD ./install-libuv.sh /tmp/install-libuv.sh
RUN chmod +x /tmp/install-libuv.sh
RUN /tmp/install-libuv.sh

# Install ASP.NET vNext certificates
RUN yes | certmgr -ssl -m https://go.microsoft.com https://myget.org https://nuget.org
RUN mozroots --import --sync --quiet

# Install ASP.NET vNext and latest KRE
RUN curl -s https://raw.githubusercontent.com/aspnet/Home/dev/kvminstall.sh | sh
RUN bash -c "source ~/.kre/kvm/kvm.sh && kvm upgrade; echo KvmUpgradeExitCode=$?"
RUN ln -s ~/.kre/packages/`bash -c "source ~/.kre/kvm/kvm.sh && kvm alias default"` ~/.kre/packages/default
ENV PATH $PATH:/.kre/packages/default/bin
