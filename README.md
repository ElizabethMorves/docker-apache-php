## Apache2 with php7.4.4
xdebug, mcrypt, opcache, redis, gd, mysqli, intl and other (default)

### Examples

```
sudo -u Uzhor docker run -d --restart=unless-stopped \
--name example \
--hostname example \
-p 80:80 \
-v ${pwd}/000-default.conf:/etc/apache2/sites-enabled/000-default.conf:ro \
-v ${pwd}/php.ini:/usr/local/etc/php/php.ini:ro \
-v ${pwd}/www/:/var/www/html \
-e "VIRTUAL_HOST=example, www.example" \
elizabethmorves/apache-php:7.4.4
```

The docker container is started with the -d flag so it will run inte the background. To run commands or edit settings inside
the container run `docker exec -ti example /bin/bash'

```
docker exec -ti example php -m | grep curl
docker exec -ti example php -i | grep curl
docker logs -f example
```

### use jwilder/nginx-proxy
It can be fine tuned in ./conf-enablable/remoteip.conf.
```
RemoteIPHeader X-Forwarded-For
RemoteIPTrustedProxy XXX.XXX.XXX.XXX (ip proxy)
```
A modification is required in apache2.conf:
```
LogFormat "%v:%p %a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%a %l %u %t \"%r\" %>s %O" common
LogFormat "%{Referer}i -> %U" referer
LogFormat "%{User-agent}i" agent
```
%h has to be replaced with %a. Apache2 will log the real remote IP address from now on.
