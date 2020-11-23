FROM z8bulon/nginx.php-fpm:leap

LABEL maintainer="Maintainers: <metanoeho@zebulon.nl>"

ENV B2EVOLUTION_VERSION=7.2.2
ENV NGINX_VERSION=1.19.4
ENV PHP-FPM_VERSION=7.4.11
ENV GOACCESS_VERSION=1.4
ENV UID=101
ENV GID=101
ENV GROUP_ADD=100
ENV TZ="Europe/Amsterdam"

WORKDIR /srv/www/htdocs

# clean original
# RUN rm /etc/nginx/ssl/vhost1.*


# get b2evolution and extract it
RUN wget https://github.com/b2evolution/b2evolution/archive/master.zip \
    && unzip b2evolution-master.zip && mv b2evolution-master b2evolution && rm b2evolution-master.zip
    
# create the _base_config.php file needed for the b2evolution installation
RUN cp b2evolution/conf/_basic_config.template.php b2evolution/conf/_basic_config.php

# COPY rootfs/

# set directory permissions
RUN 	mkdir /srv/www/nginx && mkdir /var/log/nginx \
	&& chown -R nginx:nginx /srv/www/htdocs /srv/www/nginx \
	&& chmod -R 775 /srv/www /srv/www/nginx \
	&& openssl dhparam -out /etc/nginx/dhparam.pem 2048
  
# be sure nginx is properly passing to php-fpm and fpm is responding
HEALTHCHECK --interval=10s --timeout=3s \
  CMD curl -f http://localhost/ping || exit 1

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["supervisord" ]
