#!/usr/bin/env bash

pecl install redis xdebug
docker-php-ext-enable redis xdebug

php_ersion=$(php -r "echo substr(PHP_VERSION, 0, 3);")
if [ $(awk -v v1=${php_ersion} -v v2=7.4 'BEGIN{print(v1 >= v2) ? "1" : "0"}') -eq 1 ]
then
    # 7.4 版本及以上使用该方式构建 gd 库
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
else
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
fi

docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql bcmath zip opcache sockets pcntl