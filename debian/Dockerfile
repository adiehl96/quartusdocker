FROM debian:stretch

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gconf2 \
    gconf-service \
    gvfs-bin \
    hunspell-en-us \
    libasound2 \
    libgtk2.0-0 \
    libnotify4 \
    libnss3 \
    libxss1 \
    libxtst6 \
    locales \
    python \
    wget \
    sudo \
    libgtk-3-0 \
    libatspi2.0-0 \
    libappindicator3-1 \
    libsecret-1-0 \
    xdg-utils \
    libgnome-keyring0 \
    gir1.2-gnomekeyring-1.0 \
    libappindicator1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

RUN dpkg --add-architecture i386
RUN apt update
RUN apt install -y libc6-i386
RUN apt install -y libxext6:i386
RUN apt install -y libxft2:i386
RUN apt-get install -y libsm6
RUN sudo apt-get install -y openjdk-8-jdk

ADD ./Quartus-lite-20.1.1.720-linux.tar /quartus
ADD eclipse-cpp-mars-2-linux-gtk-x86_64.tar.gz /
ADD ./qenv.sh /
RUN /quartus/setup.sh --mode unattended --accept_eula 1 --installdir /opt/quartus && \
    (cd /opt/quartus/nios2eds/bin && mv /eclipse ./eclipse_nios2 && tar xfz eclipse_nios2_plugins.tar.gz)
RUN mv /qenv.sh /opt/quartus/quartus/adm
# ENTRYPOINT [ "yes" ]
# CMD ["--64bit"]
ENTRYPOINT ["/opt/quartus/quartus/bin/quartus"]
