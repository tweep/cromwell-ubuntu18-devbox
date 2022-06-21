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


#ADD scripts/setup_os_ubuntu_18.04.sh /tmp/
#RUN /tmp/setup_os_ubuntu_18.04.sh


##
## Below we extend the original ensembl-hive image ...
##



RUN apt-get update -y \
    && apt-get install -y --no-install-recommends  \
      awscli  \
      ca-certificates \
      cpanminus \ 
      curl \
      build-essential \
      gpg gnupg \
      iputils-ping   \
      libcurl4-openssl-dev \
      libwww-curl-perl \
      lsb-release \
      maven \
      net-tools \
      netcat \
      vim \
      wget \
      &&  apt-get clean 

#
# Either copy data to /bin or use the 
# auto download

#ADD /bin/openjdk-18_linux-x64_bin.tar.gz /opt/jdk-18
#COPY /bin/cromwell-78.jar /home/Users/ubuntu/code
#COPY /bin/womtool-78.jar /home/Users/ubuntu/code


## Install java
RUN mkdir -p /opt \
#    && curl -kSL https://download.java.net/java/GA/jdk18/43f95e8614114aeaa8e8a5fcf20a682d/36/GPL/openjdk-18_linux-x64_bin.tar.gz \
#    | tar -xzC /opt
ENV JAVA_HOME=/opt/jdk-18
ENV PATH=$JAVA_HOME/bin:$PATH

## Install cromwell
WORKDIR /home/Users/ubuntu/code
ARG CW_VERSION=78
RUN wget https://github.com/broadinstitute/cromwell/releases/download/78/womtool-${CW_VERSION}.jar
RUN wget https://github.com/broadinstitute/cromwell/releases/download/78/cromwell-${CW_VERSION}.jar 

# Install miniwdl
#RUN apt-get install -y python3-pip  
#RUN pip3 install miniwdl

#RUN mkdir /etc/apt/keyrings/ 
#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg  

##RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

#RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-pluginsudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-pluginlinux/ubuntu   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

RUN useradd -ms /bin/bash ubuntu
USER ubuntu:ubuntu
#RUN usermod -aG docker ubuntu  
WORKDIR /home/ubuntu

CMD [ "/bin/bash" ]
