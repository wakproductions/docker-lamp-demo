FROM httpd:2.4.23

# curl - useful tool for debugging in the container
# mysql-client - because we're using MySQL 5.7 on a different container
# libmysqlclient-dev - needed for mysql_config, option needed to get MYSQLI driver in compile
# gcc, make - need a C compiler to build PHP
# libxml2-dev - dependency for compiling PHP
RUN apt-get update && apt-get install -y \
    mysql-client \
    libmysqlclient-dev \
    gcc \
    libxml2-dev \
    make \
    curl \
    vim

RUN curl https://www.php.net/distributions/php-5.6.40.tar.gz > /tmp/php-5.6.40.tar.gz

RUN cd /tmp && tar -zxvf php-5.6.40.tar.gz
RUN cd /tmp/php-5.6.40 && \
    ./configure --with-apxs2=/usr/local/apache2/bin/apxs --with-mysql --with-mysqli=/usr/bin/mysql_config \
    --enable-mbstring && \
    make && make install
RUN rm -rf /tmp/php-5.6.40

WORKDIR /var/www/lamp-demo
RUN mkdir -p /var/log/apache2

COPY ./lamp-demo-httpd.conf /usr/local/apache2/conf/httpd.conf

EXPOSE 80

CMD ["httpd-foreground"]