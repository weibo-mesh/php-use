<?php
// composer require motan/motan-php:dev-master
require 'vendor/autoload.php';
// define('MOTAN_PHP_ROOT', $MOTAN_PHP_ROOT . '/src/Motan/');
// require MOTAN_PHP_ROOT . 'init.php';
// define('AGENT_RUN_PATH', '/run/weibo-mesh');
define('D_CONN_DEBUG', '172.18.0.20:9100'); //for http mesh server
$url_str = 'motan2://127.0.0.1:91/com.weibo.HelloWorldService?group=motan-demo-rpc';
$url = new \Motan\URL($url_str);
$url->setConnectionTimeOut(50000);
$url->setReadTimeOut(50000);
$cx = new \Motan\Client($url);
// $params = ['hello'=>'motan-php'];
// $headers = ['Authorization'=>'Basic '  . base64_encode('qa_test050@sina.cn:mm123456')];
$rs = $cx->Hello();
if (null === $rs) {
    print_r($cx->getResponseException());
}
print_r($rs);