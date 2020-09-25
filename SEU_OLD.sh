#!/bin/sh
# Author：quzard
#/etc/storage/seu.sh
wan=''
account=''
password=''

logger -t "【校园网】" "脚本开始"
echo  "【校园网】" "脚本开始"
while :
do
    logger -t "【校园网】" "ping 114.114.114.114"
    echo  "【校园网】" "ping 114.114.114.114"
    ping -c 1 114.114.114.114 > /dev/null 2>&1
    if [ $? -eq 0 ];then
        logger -t "【校园网】" "网络连接正常"
        echo "【校园网】" "网络连接正常"
    else
        HOST_IP=$(ifconfig "$wan" | grep inet | awk '{print $2}' | tr -d "addr:")
        echo $HOST_IP
        
        login_url='https://w.seu.edu.cn:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=%2C0%2C'$account'&user_password='$password'&wlan_user_ip='$HOST_IP'&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=jlh_me60&jsVersion=3.3.2&v=2207'
        echo $login_url

        logger -t "【校园网】" "网络无法连接，开始校园网认证"
        echo "【校园网】" "网络无法连接，开始校园网认证"
        var=`curl $login_url`
        logger -t "【校园网】" "$var"
        logger -t "【校园网】" "脚本完成，5秒后将再次检查网络"
        echo "【校园网】" "$var"
        echo "【校园网】" "脚本完成，5秒后将再次检查网络"
        sleep 5
        logger -t "【校园网】" "ping 114.114.114.114"
        echo "【校园网】" "ping 114.114.114.114"
        ping -c 1 114.114.114.114 > /dev/null 2>&1
        if [ $? -eq 0 ];then
            logger -t "【校园网】" "网络连接正常"
            echo "【校园网】" "网络连接正常"
        else
            logger -t "【校园网】" "网络连接异常，请自行检查问题所在"
            echo "【校园网】" "网络连接异常，请自行检查问题所在"
        fi
    fi
    logger -t "【校园网】" "脚本结束"
    echo "【校园网】" "脚本结束"
    sleep 10s
done
