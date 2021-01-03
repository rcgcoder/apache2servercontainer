FROM ubuntu:latest
MAINTAINER rcgcoder
EXPOSE 22
EXPOSE 80
EXPOSE 443
EXPOSE 5901

ARG withUser=sae
ARG withPassword=sae
ARG withDomain=www.example.es
ARG withMail=example@letsencrypt.com
ARG withTestingCertificate=true
ARG withSecretCertificate=false

ARG TimeZone=Europe/Madrid
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf $(echo "/usr/share/zoneinfo/$TimeZone") /etc/localtime && echo "$TimeZone" > /etc/timezone
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get update
RUN apt-get install -y mc wget apache2 certbot software-properties-common python3-certbot-apache

COPY addUserWithPassword /usr/bin/addUserWithPassword
RUN chmod 777 -R /usr/bin/addUserWithPassword
COPY runcontainer_apacheserver /usr/bin/runcontainer_apacheserver
RUN chmod 777 -R /usr/bin/runcontainer_apacheserver
COPY bootstrap.sh /usr/bin/bootstrap.sh
RUN chmod 777 -R /usr/bin/bootstrap.sh

COPY secret-ssl.conf /tmp/secret-ssl.conf
RUN chmod 777 -R /tmp/secret-ssl.conf
COPY containerapacheserver-setup.sh /usr/bin/containerapacheserver-setup.sh
RUN chmod 777 -R /usr/bin/containerapacheserver-setup.sh


ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/runcontainer_apacheserver"]