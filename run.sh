#!/bin/sh

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       Run a Golang service with Weibo-Mesh.
# ./run.sh                                run hello world demo
# ./run.sh x                              clean the container and network
# ./run.sh -h                             show this help
### END ###

set -e

. .building_versions_info.sh

BASE_DIR=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))
PHP_FPM_IMAGE=weibocom/weibomesh-lnmp-php-fpm:${WEIBO_MESH_VERSION}
OPENRESTY_IMAGE=weibocom/weibomesh-lnmp-openresty:${WEIBO_MESH_VERSION}
PHP_CONTAINER_NAME=php
OR_CONTAINER_NAME=openresty
ZK_IMAGE=zookeeper
ZK_CONTAINER_NAME=weibo-mesh-zk

init_composer() {
    DO=install
    if [ ! -z $1 ]; then
        DO=$1
    fi
    docker run --rm -it -v ${BASE_DIR}/www:/app \
    --user $(id -u):$(id -g) \
    composer ${DO}
}

do_weibo_mesh_hello_world() {
    if [ -z "$(docker network ls --format {{.Name}} |grep -e '^weibo-mesh$')" ]; then
        docker network create --subnet=172.18.0.0/16 weibo-mesh
    fi

    sleep 1

    docker run -d --rm --name ${ZK_CONTAINER_NAME} \
    --net weibo-mesh \
    --ip 172.18.0.09 \
    ${ZK_IMAGE}

    sleep 2


    MOTAN_CONF_NAME=$1
    docker run -d --rm --name ${PHP_CONTAINER_NAME} \
    -v ${BASE_DIR}/www:/run/www \
    -v ${BASE_DIR}/fpm.d:/usr/local/etc/php \
    -v ${BASE_DIR}/weibo-mesh:/run/weibo-mesh \
    -v ${BASE_DIR}/weibo-mesh/client:/run/weibo-mesh/client \
    -w /run/weibo-mesh/client \
    --net weibo-mesh \
    --ip 172.18.0.10 \
    --link ${ZK_CONTAINER_NAME}:zookeeper \
    -p 9000:9000 \
    ${PHP_FPM_IMAGE} /run/weibo-mesh/php-fpm_run.sh

    sleep 1

    docker run -d --rm --name ${OR_CONTAINER_NAME} \
    -v ${BASE_DIR}/www:/run/www \
    -v ${BASE_DIR}/ngx.d:/usr/local/openresty/nginx/conf \
    -v ${BASE_DIR}/ngx.d/logs:/usr/local/openresty/nginx/logs \
    -v ${BASE_DIR}/weibo-mesh:/run/weibo-mesh \
    -v ${BASE_DIR}/weibo-mesh/server:/run/weibo-mesh/server \
    -w /run/weibo-mesh/server \
    --net weibo-mesh \
    --ip 172.18.0.20 \
    -p 80:80 \
    --link=${PHP_CONTAINER_NAME}:php \
    ${OPENRESTY_IMAGE} /run/weibo-mesh/openresty_run.sh
}

dc_clean() {
    docker stop ${OR_CONTAINER_NAME} ${PHP_CONTAINER_NAME} ${ZK_CONTAINER_NAME}
    docker network rm weibo-mesh
}


if [ $# != 0 ]; then
    if [ $1 == "x" ]; then
        dc_clean
    elif [ $1 == "-i" ]; then
        if [ ! -z $2 ]; then
            init_composer $2
        else
            init_composer
        fi
        
    elif [ $1 == "-h" ]; then
        echo "
        ./run.sh                                run hello world demo
        ./run.sh x                              clean the container and network
        ./run.sh -i                             run composer install
        ./run.sh -h                             show this help
        "
    fi
else
    do_weibo_mesh_hello_world
fi
