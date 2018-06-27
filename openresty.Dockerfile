FROM weibocom/weibo-mesh:0.0.4 AS weibo-mesh

FROM openresty/openresty:1.13.6.1-alpine
MAINTAINER idevz "zhoujing2@staff.weibo.com"

COPY --from=weibo-mesh /weibo-mesh /weibo-mesh

ENV PATH /usr/local/openresty/bin:$PATH
CMD ["/weibo-mesh"]