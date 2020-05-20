FROM php:7.3-fpm

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

ARG VSC_USERNAME
ARG VSC_USER_EMAIL
ARG VSC_USER_UID=1000
ARG VSC_USER_GID=$VSC_USER_UID

# 安装软件
RUN sed -ri 's/https?:\/\/.*\.debian\.org/https:\/\/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install git procps iproute2 lsb-release curl wget \
        vim zsh zip libzip-dev mlocate lsof net-tools libfreetype6-dev \
        libjpeg62-turbo-dev libpng-dev make autoconf gcc g++ libpcre3-dev \
        libpcre3 openssl libssl-dev sudo \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# 处理用户权限
RUN groupadd --gid $VSC_USER_GID $VSC_USERNAME \
    && useradd -s /bin/zsh --uid $VSC_USER_UID --gid $VSC_USER_GID -m $VSC_USERNAME \
    && echo $VSC_USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$VSC_USERNAME \
    && chmod 0440 /etc/sudoers.d/$VSC_USERNAME

# 扩展配置
COPY conf.d/ $PHP_INI_DIR/conf.d/

## 配置 zsh
COPY .oh-my-zsh/ /home/${VSC_USERNAME}/.oh-my-zsh
COPY .oh-my-zsh/templates/zshrc.zsh-template /home/${VSC_USERNAME}/.zshrc

# Install xdebug redis mysqli pdo_mysql bcmath gd zip opcache sockets
RUN pecl install redis xdebug \
	&& docker-php-ext-enable redis xdebug \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql bcmath zip opcache sockets pcntl

# Composer
RUN sudo -u ${VSC_USERNAME} mkdir -p /home/${VSC_USERNAME}/bin \
    && sudo -u ${VSC_USERNAME} curl -o /home/${VSC_USERNAME}/bin/composer \
    https://mirrors.aliyun.com/composer/composer.phar \
    && chmod +x /home/${VSC_USERNAME}/bin/composer \
    && sudo -u ${VSC_USERNAME} /home/${VSC_USERNAME}/bin/composer config -g \
    repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && sudo -u ${VSC_USERNAME} echo "export PATH=\$PATH:\$HOME/.composer/vendor/bin" >> /home/${VSC_USERNAME}/.envrc

# 环境变量配置
RUN echo "export USER_BIN=/home/${VSC_USERNAME}/bin" >> /home/${VSC_USERNAME}/.envrc \
    && echo "export PATH=\$USER_BIN:\$PATH " >> /home/${VSC_USERNAME}/.envrc \
    && sudo -u ${VSC_USERNAME} echo ". ~/.envrc" >>  /home/${VSC_USERNAME}/.zshrc