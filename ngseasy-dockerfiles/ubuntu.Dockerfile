# base image
FROM ubuntu:14.04.3
# Maintainer
MAINTAINER Stephen Newhouse stephen.j.newhouse@gmail.com
# Remain current
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get dist-upgrade -y
# Basic dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  apt-utils \
  automake \
  ant \
  bash \
  binutils \
  perl \
  bioperl \
  build-essential \
  bzip2 \
  c++11 \
  cdbs \
  cmake \
  cron \
  curl \
  dkms \
  dpkg-dev \
  g++ \
  gpp \
  gcc \
  gfortran \
  git \
  git-core \
  libblas-dev \
  libatlas-dev \
  libbz2-dev \
  liblzma-dev \
  libpcre3-dev \
  libreadline-dev \
  make \
  mercurial \
  php5-curl \
  python python-dev python-yaml ncurses-dev zlib1g-dev python-numpy python-pip \
  sudo \
  subversion \
  tabix \
  tree \
  unzip \
  vim \
  wget \
  python-software-properties \
  libc-bin \
  llvm \
  libconfig-dev \
  ncurses-dev \
  zlib1g-dev \
  yum \
  libX11-dev libXpm-dev libXft-dev libXext-dev \
  asciidoc

# upgrade java
RUN apt-get install -y openjdk-7-jdk openjdk-7-doc openjdk-7-jre-lib

# set java
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
RUN sed -i 'aPATH=$PATH:/usr/lib/jvm/java-7-openjdk-amd64/jre/bin' /root/.bashrc

# Create a pipeline user:pipeman and group:ngsgroup

RUN useradd -m -s /bin/bash pipeman && \
  cd /home/pipeman && \
  echo "#bash config file for user pipeman" >> /home/pipeman/.bashrc

RUN groupadd ngsgroup && \
  usermod -aG ngsgroup pipeman && \
  usermod -aG sudo pipeman

# make pipeline install dirs
RUN mkdir /usr/local/pipeline && \
  chown pipeman:ngsgroup /usr/local/pipeline

# PERMISSIONS
RUN chmod -R 777 /usr/local/pipeline
RUN chown -R pipeman:ngsgroup /usr/local/pipeline

# Cleanup the temp dir
RUN rm -rvf /tmp/*

# open ports private only
EXPOSE 8080

# Use baseimage-docker's bash.
CMD ["/bin/bash"]

# Clean up APT when done.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
