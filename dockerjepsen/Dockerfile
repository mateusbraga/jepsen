# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang:1.4.2

MAINTAINER Mateus Braga <mateus.a.braga@gmail.com>

RUN apt-get update && apt-get install -y \
    openssh-server \
    vim \
    sudo \
    wget \
    curl \
    unzip \
    iptables \
    logrotate \
    git-core

# config ssh stuff
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22


COPY startscript.sh /opt/ 


CMD ["/opt/startscript.sh"]
