FROM ubuntu:latest
MAINTAINER rcgcoder
EXPOSE 22


ARG withUser=sae
ARG withPassword=sae

ARG TimeZone=Europe/Madrid
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf $(echo "/usr/share/zoneinfo/$TimeZone") /etc/localtime && echo "$TimeZone" > /etc/timezone
RUN apt-get update

COPY runcontainer_apacheserver /usr/bin/runcontainer_apacheserver
RUN chmod 777 -R /usr/bin/runcontainer_apacheserver
COPY containerapacheserver-setup.sh /usr/bin/containerapacheserver-setup.sh
RUN chmod 777 -R /usr/bin/containerapacheserver-setup.sh
COPY bootstrap.sh /usr/bin/bootstrap.sh
RUN chmod 777 -R /usr/bin/bootstrap.sh

ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/runcontainer_apacheserver"]