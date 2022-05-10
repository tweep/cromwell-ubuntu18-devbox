#
# Dockerfile to build a developer environment 
# to develop cromwell based workflows. 
#
# docker build -t cromwell-dev .
#
# docker run -it cromwell-dev 


FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

RUN apt-get update

RUN apt-get install -y --no-install-recommends git software-properties-common maven curl \
    &&  apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install java
RUN mkdir -p /opt \
    && curl -kSL https://download.java.net/java/GA/jdk18/43f95e8614114aeaa8e8a5fcf20a682d/36/GPL/openjdk-18_linux-x64_bin.tar.gz \
    | tar -xzC /opt
ENV JAVA_HOME=/opt/jdk-18
ENV PATH=$JAVA_HOME/bin:$PATH


# Dependencies
#FROM ubuntu:18.04 AS os_installer
#ADD scripts/setup_os_ubuntu_18.04.sh /tmp/
#RUN /tmp/setup_os_ubuntu_18.04.sh


##
## Below we extend the original ensembl-hive image ...
##


RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
      vim \
      awscli \
      cpanminus \
      build-essential \
      libcurl4-openssl-dev \
      net-tools \
      netcat \
      libwww-curl-perl \
      iputils-ping  

# libcurl4-openssl-dev required for WWW::Curl::Easy / Bio::GNE::Hive::Utils

RUN curl --insecure -L https://cpanmin.us | perl - App::cpanminus
RUN cpanm File::Slurp IPC::System::Simple Module::Build Test::Differences
RUN cpanm -v AWS::CLIWrapper String::Random Switch Archive::Extract AWS::CLIWrapper 

# modules for standard pipelines
RUN cpanm -v File::Temp Test::utf8 Test::TempDir::Tiny Test::File Test::Files

RUN cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)

RUN apt-get install -y cgroup-bin 

#ENV INFLUX_COLLECT_METRICS  --collect=cpu,memory,disk,network 

#ENTRYPOINT [ "/repo/ensembl-hive/scripts/dev/simple_init.py" ]
CMD [ "/bin/bash" ]
