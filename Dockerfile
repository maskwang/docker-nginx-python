FROM phusion/baseimage:0.9.15

MAINTAINER Mask Wang, mask.wang.cn@gmail.com

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# Nginx-Python Installation
RUN apt-get update
RUN apt-get install -y vim curl wget build-essential python-software-properties\
               telnet nmap g++ libmysqlclient-dev python-dev python-pip\
               libzmq-dev pkg-config libtool autoconf

RUN pip install MySQL-python croniter pyzmq

RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update

RUN apt-get install -y nginx

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN mkdir -p        /var/www
ADD build/default   /etc/nginx/sites-available/default
RUN mkdir -p        /etc/service/nginx
ADD build/nginx.sh  /etc/service/nginx/run
RUN chmod +x        /etc/service/nginx/run

EXPOSE 80
# End Nginx-Python

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
