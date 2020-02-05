## 简介

本项目结合 VS Code 的 Remote - Containers 插件搭建 nginx、PHP 开发环境。

## 环境搭建

首先需要安装 Docker，然后搭建好 database 数据库项目环境。
只需将本项目克隆至开发项目目录下，并将 .env.example 中的环境变量配置复制到 .env 文件中并配置值。

VSC_USERNAME #php环境运行用户和Git用户名
VSC_USER_EMAIL #Git的Email
CONTAINER_NAME #php实例名称

>注意：在 Nginx 的 `fastcgi_pass   docker-php-1:9000;` 配置中 docker-php-1 值需要与 CONTAINER_NAME 配置值相同。