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

php generate-phpt.php  -f <function_name> |-c <class_name> -m <method_name> -b|e|v [-s skipif:ini:clean:done] [-k win|notwin|64b|not64b] [-x ext]

php /Users/idevz/code/src/php-5.3.27/scripts/dev/generate-phpt.phar -f sin -b -s 'skipif:ini:clean:done'
TEST_PHP_EXECUTABLE=/usr/local/opt/php@7.1/bin/php php $MCODE/src/php-7.2.5/run-tests.php


if [ $# != 0 ]; then
    if [ $1 == "x" ]; then
        dc_clean
    elif [ $1 == "-h" ]; then
        echo "
        ./run.sh                                run hello world demo
        ./run.sh x                              clean the container and network
        ./run.sh -h                             show this help
        "
    fi
else
    do_weibo_mesh_hello_world
fi
