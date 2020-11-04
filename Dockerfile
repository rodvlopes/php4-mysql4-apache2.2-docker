FROM ubuntu:14.04 as build
RUN apt-get update && apt-get install -y --force-yes \
  build-essential libncurses5-dev zlib1g-dev wget flex

WORKDIR /tmp

# Build Apache 2.2
ADD httpd-2.2.34.tar.bz2 .
RUN cd httpd-2.2.34 \
  &&./configure --prefix=/usr/local/apache2 --enable-mods-shared=all --enable-deflate --enable-proxy --enable-proxy-balancer --enable-proxy-http \
  && make \
  && make install

# Build PHP 4
ADD php-4.4.9.tar.bz2 .
ADD php.ini /usr/local/apache2/php.ini
RUN cd php-4.4.9 \
  && ./configure --with-apxs2=/usr/local/apache2/bin/apxs --with-mysql --enable-force-cgi-redirect --disable-cgi --with-zlib \
  --with-config-file-path=/usr/local/apache2 \
  && make && make install

# Setup PHP to Run on Apache
RUN echo 'AddType application/x-httpd-php php' >> /usr/local/apache2/conf/httpd.conf \
  && sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /usr/local/apache2/conf/httpd.conf

# Build Mysql 4
ADD mysql-4.1.22.tar.bz2 .
RUN cd mysql-4.1.22 \
  && ./configure --prefix=/usr/local/mysql \
  && make && make install


FROM ubuntu:14.04

# Setup Mysql to Run
ADD my.cnf /usr/local/mysql/my.cnf
RUN groupadd -r mysql && useradd -r -g mysql mysql \
  && mkdir /usr/local/mysql/var \
  && chown -R root /usr/local/mysql && chown -R mysql /usr/local/mysql/var && chgrp -R mysql /usr/local/mysql

COPY --from=build /usr/local/apache2 /usr/local/apache2
COPY --from=build /usr/local/mysql /usr/local/mysql

ENV PATH="${PATH}:/usr/local/apache2/bin/:/usr/local/mysql/bin/"
VOLUME /usr/local/mysql/var /usr/local/apache2/htdocs/
EXPOSE 80 
CMD apachectl start && mysqld_safe --defaults-file=/usr/local/mysql/my.cnf 
