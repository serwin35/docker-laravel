FROM nginx:stable-alpine

ARG NGINXGROUP
ARG NGINXUSER

ENV NGINXGROUP=${NGINXGROUP}
ENV NGINXUSER=${NGINXUSER}

RUN sed -i "s/user www-data/user ${NGINXUSER}/g" /etc/nginx/nginx.conf

ADD ./.docker/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./.docker/nginx/default.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /var/www/html

RUN addgroup --system ${NGINXGROUP}; exit 0
RUN adduser --system -G ${NGINXGROUP} -s /bin/sh -D ${NGINXUSER}; exit 0

#COPY config/vhost.conf /etc/apache2/sites-enabled/vhost.conf
