FROM scratch
MAINTAINER Genti Topija <genti.t@gmail.com>

COPY caddy /bin/
COPY html /var/www/html
EXPOSE 80 443 2015
WORKDIR /var/www/html
CMD ["/bin/caddy"]
