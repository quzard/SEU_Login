#! /bin/bash
# Copyright (C) quzard

echo='echo -e' && [ -n "$(echo -e|grep e)" ] && echo=echo
[ -z "$1" ] && test=0 || test=$1

echo "***********************************************"
echo "**                 欢迎使用                  **"
echo "**                seu自动登录脚本                 **"
echo "**                             by  quzard    **"
echo "***********************************************"
read -p "请输入你的seu账号 > " username
while [ -z $username ];
do
	read -p "请输入你的seu账号 > " username
done

read -p "请输入你的seu账号密码 > " password
while [ -z $password ];
do
	read -p "请输入你的seu账号密码 > " password
done

# 是否手动输入校园网ip y/n
while [ 1 ]
do
	read -r -p "是否手动输入校园网ip y/n > " wan_enable
	case $wan_enable in
	    [yY][eE][sS]|[yY])
			read -r -p "请输入ip地址 > " wan_ip
			break
			;;

	    [nN][oO]|[nN])
			read -r -p "请输入你的外网网卡 通过ifconfig获取 > " ipv4_interface
			wan_ip=$(/sbin/ifconfig $ipv4_interface |awk '/inet/ {print $2}'|grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}') 
			echo "获取到的wan_ip为$wan_ip"
			echo "如果该wan_ip不是预期的，请退出脚本重新设置"
			break
	       	;;

	    *)
		echo "非法输入，重新输入"
		;;
	esac
done

# 是否宿舍网登录 y/n
while [ 1 ]
do
	read -r -p "是否宿舍网登录 y/n > " dormitory_enable

	case $dormitory_enable in
	    [yY][eE][sS]|[yY])
			$echo "请选择登录方式"	
			$echo " 1 移动"
			$echo " 2 电信"
			$echo " 3 联通"
			$echo " 4 seu"
			echo -----------------------------------------------
			read -p "请输入相应数字 > " method
			if [ -z $method ];then
				echo 安装已取消
				exit;
			elif [ "$method" = "1" ];then
				METHOD='%40cmcc'
			elif [ "$method" = "2" ];then
				METHOD='%40telecom'
			elif [ "$method" = "3" ];then
				METHOD='%40unicom'
			elif [ "$method" = "4" ];then
				METHOD=''
			fi
			login_url_dor='http://10.80.128.2:801/eportal/?c=Portal&a=login&callback=dr1004&login_method=1&user_account=%2C0%2C'$username$METHOD'&user_password='$password'&wlan_user_ip='$wan_ip'&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.3.3&v=2824'
			logout_url_dor_mac='http://10.80.128.2:801/eportal/?c=Portal&a=unbind_mac&callback=dr1005&user_account='$username'&wlan_user_mac=&wlan_user_ip='$wan_ip'&jsVersion=3.3.3&v=3180'
			logout_url_dor='http://10.80.128.2:801/eportal/?c=Portal&a=logout&callback=dr1006&login_method=1&user_account=drcom&user_password=&ac_logout=1&register_mode=1&wlan_user_ip='$wan_ip'&wlan_user_ipv6=&wlan_vlan_id=0&wlan_user_mac=&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.3.3&v=10006'
			break
			;;

	    [nN][oO]|[nN])
			login_url='https://w.seu.edu.cn:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=%2C0%2C'$username'&user_password='$password'&wlan_user_ip='$wan_ip'&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=jlh_me60&jsVersion=3.3.2&v=2207'
			logout_url='https://w.seu.edu.cn:801/eportal/?c=Portal&a=logout&callback=dr1004&login_method=1&user_account=drcom&user_password=&ac_logout=1&register_mode=1&wlan_user_ip='$wan_ip'&wlan_user_ipv6=&wlan_vlan_id=1&wlan_user_mac=&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.3.2&v=1385'
	       	break
	       	;;

	    *)
		echo "非法输入，重新输入"
		;;
	esac
done

function login(){
	case $dormitory_enable in
	    [yY][eE][sS]|[yY])
			var=`curl -k $login_url_dor`
			result_1=$(echo $var | grep "u8ba4")
			result_2=$(echo $var | grep "ret_code")
			result_3=$(echo $var | grep "QXV0aGVudGljYXRpb24gRmFpbCBFcnJDb2RlPTA1")
			if [[ "$result_1" != "" ]]
			then
				echo "`date "+%Y-%m-%d %H:%M:%S"`【宿舍网认证成功】""$var"
			elif [[ "$result_3" != "" ]]
			then
				echo "`date "+%Y-%m-%d %H:%M:%S"`【账号存在问题】""$var"
			elif [[ "$result_2" != "" ]]
			then
				echo "`date "+%Y-%m-%d %H:%M:%S"`【宿舍网已经登陆】""$var"
			else
				echo "`date "+%Y-%m-%d %H:%M:%S"`【宿舍网认证失败】""$var"
			fi
			;;
	[nN][oO]|[nN])
		var=`curl -k $login_url`
		result_1=$(echo $var | grep "u8ba4")
		result_2=$(echo $var | grep "ret_code")
		result_3=$(echo $var | grep "QXV0aGVudGljYXRpb24gRmFpbCBFcnJDb2RlPTA1")
		if [[ "$result_1" != "" ]]
		then
			echo "`date "+%Y-%m-%d %H:%M:%S"`【校园网认证成功】""$var"
		elif [[ "$result_3" != "" ]]
		then
			echo "`date "+%Y-%m-%d %H:%M:%S"`【账号存在问题】""$var"
		elif [[ "$result_2" != "" ]]
		then
			echo "`date "+%Y-%m-%d %H:%M:%S"`【校园网已经登陆】""$var"
		else
			echo "`date "+%Y-%m-%d %H:%M:%S"`【校园网认证失败】""$var"
		fi
		;;
	esac
}

function logout(){
	case $dormitory_enable in
	    [yY][eE][sS]|[yY])
			echo "`date "+%Y-%m-%d %H:%M:%S"`【宿舍网注销】">> ${logfile}
			for num in {1..2..1}
			do   
				var=`curl -k $logout_url_dor_mac`
				result_1=$(echo $var | grep "u89e3")
				result_2=$(echo $var | grep "u7528")
				if [[ "$result_1" != "" ]]
				then
					echo "`date "+%Y-%m-%d %H:%M:%S"`【宿舍网-解绑Mac成功】""$var"
				elif [[ "$result_2" != "" ]]
				then
					echo "`date "+%Y-%m-%d %H:%M:%S"`【宿舍网-用户不在线】""$var"
				else
					echo "`date "+%Y-%m-%d %H:%M:%S"`【宿舍网-解绑Mac失败】""$var"
				fi
				var=`curl -k $logout_url_dor`
				result_1=$(echo $var | grep "u6ce8")
				result_2=$(echo $var | grep "u7528")
				if [[ "$result_1" != "" ]]
				then
					echo "`date "+%Y-%m-%d %H:%M:%S"`【宿舍网注销成功】""$var"
				elif [[ "$result_2" != "" ]]
				then
					echo "`date "+%Y-%m-%d %H:%M:%S"`【宿舍网-用户不在线】""$var"
				else
					echo "`date "+%Y-%m-%d %H:%M:%S"`【宿舍网注销失败】""$var"
				fi
				sleep 3s
			done
			;;
	[nN][oO]|[nN])
		var=`curl -k $logout_url`
		result_1=$(echo $var | grep "u6ce8")
		result_2=$(echo $var | grep "u7528")
		if [[ "$result_1" != "" ]]
		then
			echo "`date "+%Y-%m-%d %H:%M:%S"`【校园网注销成功】""$var"
		elif [[ "$result_2" != "" ]]
		then
			echo "`date "+%Y-%m-%d %H:%M:%S"`【校园网-用户不在线】""$var"
		else
			echo "`date "+%Y-%m-%d %H:%M:%S"`【校园网注销失败】""$var"
		fi
		;;
	esac
}



while [ 1 ]
do
	ping -c 1 www.baidu.com > /dev/null 2>&1
	if [ $? -eq 0 ];then
		echo "`date "+%Y-%m-%d %H:%M:%S"`网络连接不正常"
		echo "wan_ip:"$wan_ip
		login
	fi
	sleep 2s
done
