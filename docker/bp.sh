#!/bin/sh

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       Build and push Docker image.
# for LORMP development environment
### END ###

set -e
BASE_DIR=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))

WEIBO_MESH_VERSION=${WEIBO_MESH_VERSION:-0.0.5}
WEIBO_MESH_RELEASE=${WEIBO_MESH_RELEASE:-1}

NOTIC_PREFIX="\n - --- --- "
NOTIC_SUFFIX=" --- --- -\n "

xnotic() {
	echo ${NOTIC_PREFIX}$1${NOTIC_SUFFIX}
}

################################################  Docker images Build Start  ################################################
images_bp() {
	ONE=$1
	docker build -t weibocom/weibomesh-lnmp-${ONE}:${WEIBO_MESH_VERSION} -f ./${ONE}.Dockerfile .
	xnotic "docker build done."
	if [ $(uname) == "Darwin" ]; then
		docker push weibocom/weibomesh-lnmp-${ONE}:${WEIBO_MESH_VERSION}
		xnotic "docker push to public hub done."
	fi
}

################################################ build images
build_docker_images() {
	for one in php-fpm openresty; do
		images_bp $one
		xnotic "build docker images done."
	done
}

################################################ run

build_docker_images
