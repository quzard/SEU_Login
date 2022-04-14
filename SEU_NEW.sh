#!/bin/sh
# Author：quzard
#/etc/storage/seu.sh

# 选择一种登录方式 将相应的METHOD取消注释
# 1.教育网
# METHOD=''
# 2.移动  
METHOD='%40cmcc'
# 3.电信  
# METHOD='%40telecom'
# 4.联通  
# METHOD='%40unicom'

wan='apclii0'
ACCOUNT=''
PASSWORD=''
time=$(date "+%Y.%m.%d-%H.%M.%S")

ping -c 1 114.114.114.114 > /dev/null 2>&1

if [ $? -eq 0 ];then
    logger -t "校园网" "$time 网络连接正常"
    echo "校园网" "$time 网络连接正常"
else
    HOST_IP=$(ifconfig "$wan" | grep inet | awk '{print $2}' | tr -d "addr:")
    echo $HOST_IP
    
    login_url='http://10.80.128.2:801/eportal/?c=Portal&a=login&callback=dr1004&login_method=1&user_account=%2C0%2C'$ACCOUNT$METHOD'&user_password='$PASSWORD'&wlan_user_ip='$HOST_IP'&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.3.3&v=2824'
    echo $login_url

    logger -t "校园网" "$time 网络无法连接，开始校园网认证"
    echo "校园网" "$time 网络无法连接，开始校园网认证"

    var=`curl $login_url`

    logger -t "校园网" "$var"
    echo "校园网" "$var"
fi
