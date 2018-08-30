FROM weibocom/weibo-mesh:0.0.4 AS weibo-mesh

FROM php:7.2.6-fpm-alpine3.7
MAINTAINER idevz "zhoujing2@staff.weibo.com"

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=weibo-mesh /weibo-mesh /weibo-mesh

ENV PATH /usr/local/sbin:$PATH
CMD ["/weibo-mesh"]