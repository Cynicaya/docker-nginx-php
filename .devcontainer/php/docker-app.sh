#!/bin/bash

install () {

    name=$1
    case $name in
        nginx)
            curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null \
            && gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg \
            && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian `lsb_release -cs` nginx" \
            | sudo tee /etc/apt/sources.list.d/nginx.list \
            && sudo apt update && sudo apt install -y nginx \
            && USERNAME=$(echo `whoami`) \
            && sudo sed -ri "s/user.*nginx/user ${USERNAME}/g" /etc/nginx/nginx.conf
        ;;
        node)
            curl -sL https://deb.nodesource.com/setup_14.x | sudo bash - \
            && sudo apt update && sudo apt install -y nodejs
        ;;
        yarn)
            curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
            && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
            && sudo apt update && sudo apt install -y --no-install-recommends yarn
        ;;
        *)
            echo "-i|--install [nginx|node|yarn]"
            exit 1
        ;;
    esac
}

# -------------------------------------------------------------------------------------
# 帮助函数
# -------------------------------------------------------------------------------------
help() {
    echo "docker-app [-h] [-i]"
    echo "  -i|--install    Install Application"
    echo "  -h              Show help"
}

# -------------------------------------------------------------------------------------
# 定义项目变量
# -------------------------------------------------------------------------------------

INSTALL=''
HELP=''
# 选项参数值
value=''

while [[ $# > 0 ]];do
  key="$1"
  value="$2"

  case $key in
      -i|--install)
        INSTALL="1"

        if [ ! -z "$value" ]; then
            shift
        fi
      ;;
      -h|--help)
        HELP="1"
      ;;
      *)
        echo "Unknown option."
        help
        exit 1
      ;;
  esac

  shift
done

# -------------------------------------------------------------------------------------
# 脚本入口函数
# -------------------------------------------------------------------------------------
main() {

    # 安装
    if [ "$INSTALL" = "1" ]; then
        install $value
        return
    fi

    # 帮助信息
    if [ "$HELP" = "1" ]; then
        help
        return
    fi

    help
}

main