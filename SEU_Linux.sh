#!/bin/sh
logfile="seu-net.log"
echo "`date "+%Y-%m-%d %H:%M:%S"` 【启动】"
username=""
password=""
wan_ip=""
dormitory_enable="1"
method=""
function login(){
    if [ -z "$username" ]; then
        exit 1
    elif [ -z "$password" ]; then
        exit 1
    elif [ -z "$wan_ip" ]; then
        exit 1
    fi

    if [ "$dormitory_enable" -eq "1" ];then

        case $method in
            "") METHOD='%40cmcc';;
            "1") METHOD='%40telecom';;
            "2") METHOD='%40unicom';;
            "3") METHOD='';;
            *) echo "请选择正确的登录方式";;
        esac

        login_url='http://10.80.128.2:801/eportal/?c=Portal&a=login&callback=dr1004&login_method=1&user_account=%2C0%2C'$username$METHOD'&user_password='$password'&wlan_user_ip='$wan_ip'&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.3.3&v=2824'
        var=`curl -k $login_url`
        result_1=$(echo $var | grep "u8ba4")
        result_2=$(echo $var | grep "ret_code")
        result_3=$(echo $var | grep "QXV0aGVudGljYXRpb24gRmFpbCBFcnJDb2RlPTA1")

        if [[ "$result_1" != "" ]]
        then
            echo "【宿舍网认证成功】""$var"
        elif [[ "$result_3" != "" ]]
        then
            echo "【账号存在问题】""$var"
        elif [[ "$result_2" != "" ]]
        then
            echo "【宿舍网已经登陆】""$var"
        else
            echo "【宿舍网认证失败】""$var"
        fi
    else
        login_url='https://w.seu.edu.cn:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=%2C0%2C'$username'&user_password='$password'&wlan_user_ip='$wan_ip'&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=jlh_me60&jsVersion=3.3.2&v=2207'
        var=`curl -k $login_url`
        result_1=$(echo $var | grep "u8ba4")
        result_2=$(echo $var | grep "ret_code")
        result_3=$(echo $var | grep "QXV0aGVudGljYXRpb24gRmFpbCBFcnJDb2RlPTA1")

        if [[ "$result_1" != "" ]]
        then
            echo "【校园网认证成功】""$var"
        elif [[ "$result_3" != "" ]]
        then
            echo "【账号存在问题】""$var"
        elif [[ "$result_2" != "" ]]
        then
            echo "【校园网已经登陆】""$var"
        else
            echo "【校园网认证失败】""$var"
        fi
    fi
}


# 启动参数
if [ "$1" ] ;then
    [ $1 == "login" ] && login
    exit
fi

while [ 1 ]
do
    autologin="1"
    # echo "`date "+%Y-%m-%d %H:%M:%S"` 正常运行"
    if [ "$autologin" -eq "1" ];then
        ping -c 1 www.baidu.com > /dev/null 2>&1
        if [ $? -eq 1 ];then
            sleep 1s
            ping -c 1 www.baidu.com > /dev/null 2>&1
            if [ $? -eq 1 ];then
                echo "网络连接不正常"
                login
            fi
        fi
    fi
    sleep 1s
done
