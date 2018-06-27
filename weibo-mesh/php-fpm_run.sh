#!/bin/sh

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       Run a Weibo-Mesh Container, with PHP Or OpenResty.
#	User input a build type, program will do the building things:
#	like:
#   ./x_run.sh
### END ###

set -ex

/usr/local/sbin/php-fpm -c /usr/local/etc/php/php.ini -D
/weibo-mesh -c /run/weibo-mesh/client-mesh.yaml