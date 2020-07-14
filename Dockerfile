FROM ubuntu:latest
MAINTAINER rcgcoder
EXPOSE 22


ARG withUser=sae
ARG withPassword=sae
ARG withDomain=www.example.es
ARG withEmail=example@letsencrypt.com

ARG TimeZone=Europe/Madrid
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf $(echo "/usr/share/zoneinfo/$TimeZone") /etc/localtime && echo "$TimeZone" > /etc/timezone
RUN apt-get update
RUN apt-get install -y apache2 certbot software-properties-common python3-certbot-apache

RUN certbot --apache -m ricardo.cantabrana@gmail.com -d cantabrana.no-ip.org -n

COPY runcontainer_apacheserver /usr/bin/runcontainer_apacheserver
RUN chmod 777 -R /usr/bin/runcontainer_apacheserver
COPY containerapacheserver-setup.sh /usr/bin/containerapacheserver-setup.sh
RUN chmod 777 -R /usr/bin/containerapacheserver-setup.sh
COPY bootstrap.sh /usr/bin/bootstrap.sh
RUN chmod 777 -R /usr/bin/bootstrap.sh

ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/runcontainer_apacheserver"]