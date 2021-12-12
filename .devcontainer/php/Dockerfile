ARG PHP_VERSION
FROM php:${PHP_VERSION}

ARG USERNAME
ARG USER_UID
ARG USER_GID=${USER_UID}
ARG LANG
ENV LANG=${LANG}

# 扩展配置
COPY conf.d/ $PHP_INI_DIR/conf.d/
COPY ./*.sh /tmp/

# 构建PHP
RUN sed -ri 's/https?:\/\/.*\.debian\.org/https:\/\/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install git procps iproute2 lsb-release curl wget \
        vim zip libzip-dev mlocate lsof net-tools libfreetype6-dev \
        libjpeg62-turbo-dev libpng-dev make autoconf gcc g++ libpcre3-dev \
        libpcre3 openssl libssl-dev sudo jq gnupg2 ca-certificates \
    #
    # 安装扩展
    && /tmp/install-ext.sh && rm -f /tmp/install-ext.sh \
    #
    # 处理用户权限
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    # && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} \
    #
    # Composer
    && mkdir -p /home/${USERNAME}/bin \
    && curl -o /home/${USERNAME}/bin/composer https://getcomposer.org/download/latest-stable/composer.phar \
    && chmod +x /home/${USERNAME}/bin/composer \
    && /home/${USERNAME}/bin/composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && mv /tmp/docker-app.sh /home/${USERNAME}/bin/docker-app \
    #
    # 环境变量配置
    && mv /tmp/bashrc.sh /home/${USERNAME}/.bashrc \
    && echo "export PATH=\$PATH:\$HOME/.composer/vendor/bin" >> /home/${USERNAME}/.bashrc \
    #
    # 修改 PHP 运行用户
    && sed -ri "s/user.*=.*www-data/user = ${USERNAME}/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -ri "s/group.*=.*www-data/group = ${USERNAME}/g" /usr/local/etc/php-fpm.d/www.conf \
    #
    # 清理包缓存信息
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*