#!/bin/bash
echo "Please input school code:"
read school
echo "开始获取操作系统版本......"
#version=`cat /etc/*-release | grep release | awk '!a[$0]++' | awk '{print $3}'`
#version=`cat /etc/*-release | grep release | awk '!a[$0]++' | grep -o '[0-9]\{1\}\.[0-9]\{1\}'`
version=`cat /etc/*-release | grep release | awk '!a[$0]++' | tr -cd "[0-9.]"`
if  [[ "$version" =~ ^5.\s* ]];then
  echo "version is 5"
elif [[ "$version" =~ ^6.\s* ]];then
  echo "version is 6"
elif [[ "$version" =~ ^7.\s* ]];then
  echo "version is 7"
else
  echo "version is unknown"
fi
hostlen=`hostname | awk '{print length($0)}'`
if [[ $hostlen -le 4 ]] || [[ `hostname` =~ ^localhost.\s* ]];then
  hostname=${school}${HOSTNAME}
  echo "修改主机名为："
  echo $hostname
  if [[ "$version" =~ ^7.\s* ]];then
    hostnamectl set-hostname $hostname
    hostname $hostname
    #env HOSTNAME=$hostname
    sed -i "s/127\.0\.0\.1.*/& $hostname/g" /etc/hosts
  elif [[ "$version" =~ ^6.\s* ]];then
    sed -i 's/HOSTNAME=/#HOSTNAME=/g' /etc/sysconfig/network
    echo "HOSTNAME=$hostname" >>/etc/sysconfig/network
    #echo $hostname | sed 's/127\.0\.0\.1.*/ &1/g' /etc/hosts
    hostname $hostname
    #env HOSTNAME=$hostname
    sed -i "s/127\.0\.0\.1.*/& $hostname/g" /etc/hosts
  elif [[ "$version" =~ ^5.\s* ]];then
    echo "请手动修改主机名"
  else
    echo "版本不符合规定"
  fi
else
  echo "主机名合格，不需要修改"
  if [[ $HOSTNAME = `cat /etc/hosts | grep 127.0.0.1 | awk '{print $NF}'` ]];then
    echo "/etc/hosts已添加过hostname,ok"
  else
    hostname=`hostname`
    echo "正添加hostname到/etc/hosts......"
    sed -i "s/127\.0\.0\.1.*/& $hostname/g" /etc/hosts
  fi
fi
#####判断目录是否存在并输出目录所在磁盘使用率#####
#pingnet=`ping -c 5 scu.edu.cn | grep icmp_seq | awk '{print $5}' | head -n1`
pingnet=`ping -c 5 scu.edu.cn | grep icmp_seq | awk '{print $0}' | head -n1`
echo "进入目录/speedec/download,下载文件......"
#if [[ $pingnet =~ ^icmp_seq\s* ]]; then 
#if [[ $pingnet =~ ^64\ bytes\s* ]]; then
if [[ $pingnet =~ "icmp_seq" ]]; then
  if [ ! -d "/speedec/download" ]; then
    mkdir -p /speedec/download
    cd /speedec/download/ 
    echo "开始下载文件......"
    if [[ "$version" =~ ^7.\s* ]];then
      wget -c http://sbc.scu.edu.cn/speed_download/zabbix-agent-3.4.15-1.el7.x86_64.rpm
	  wget -c http://sbc.scu.edu.cn/speed_download/check_file.sh
      echo "下载完成"
    elif [[ "$version" =~ ^6.\s* ]];then
      wget -c http://sbc.scu.edu.cn/speed_download/zabbix-agent-3.4.15-1.el6.x86_64.rpm
	  wget -c http://sbc.scu.edu.cn/speed_download/check_file.sh
      echo "下载完成"
    elif [[ "$version" =~ ^5.\s* ]];then
      wget -c http://sbc.scu.edu.cn/speed_download/zabbix-agent-3.4.15-1.el5.x86_64.rpm
	  wget -c http://sbc.scu.edu.cn/speed_download/check_file.sh
      echo "下载完成"
    else
      echo "下载失败"
    fi
  elif [ -d "/speedec/download" ]; then
    cd /speedec/download/
    echo "开始下载文件......"
    if [[ "$version" =~ ^7.\s* ]];then
      wget -c http://sbc.scu.edu.cn/speed_download/zabbix-agent-3.4.15-1.el7.x86_64.rpm
	  wget -c http://sbc.scu.edu.cn/speed_download/check_file.sh
      echo "下载完成"
    elif [[ "$version" =~ ^6.\s* ]];then
      wget -c http://sbc.scu.edu.cn/speed_download/zabbix-agent-3.4.15-1.el6.x86_64.rpm
	  wget -c http://sbc.scu.edu.cn/speed_download/check_file.sh
      echo "下载完成"
    elif [[ "$version" =~ ^5.\s* ]];then
      wget -c http://sbc.scu.edu.cn/speed_download/zabbix-agent-3.4.15-1.el5.x86_64.rpm
	  wget -c http://sbc.scu.edu.cn/speed_download/check_file.sh
      echo "下载完成"
    else
      echo "下载失败"
    fi
  else
    echo "未知错误,建议手动上传"
  fi
else
  if [ ! -d "/speedec/download" ]; then
    mkdir -p /speedec/download
    cd /speedec/download
    echo "请手动上传安装包和脚本,再执行此脚本！"
  else
    cd /speedec/download
    echo "请手动上传安装包和脚本,再执行此脚本！"
  fi
fi
    
###开始安装zabbix###
echo "开始安装zabbix客户端"
package=`ls -l /speedec/download/ | grep zabbix-agent | awk '{print $9}'`
if [ -f "$package" ];then
  cd /speedec/download
  rpm -ivh $package
  mkdir /etc/zabbix/zabbix_agentd.d/scripts/
  chmod -R 755 /etc/zabbix/zabbix_agentd.d/scripts/
  cd /etc/zabbix/zabbix_agentd.d/scripts/
  mv /speedec/download/check_file.sh ./
  chmod 777 check_file.sh
else
  echo "请重新下载安装包"
fi
#for package in "zabbix-agent-3.4.15-1.el5.x86_64.rpm zabbix-agent-3.4.15-1.el6.x86_64.rpm zabbix-agent-3.4.15-1.el7.x86_64.rpm";
#do
#  if [ -f "$package" ];then
#    rpm -ivh $package
#  else
#    echo "请重新下载安装包"
#  fi
#done
###修改配置文件###
echo "修改配置文件..."
sed -i 's/Server=127.0.0.1/Server=120.26.209.247/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=120.26.209.247/g' /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=`hostname`/g" /etc/zabbix/zabbix_agentd.conf
echo "UserParameter=backupfile.catalog,/etc/zabbix/zabbix_agentd.d/scripts/check_file.sh" >>/etc/zabbix/zabbix_agentd.conf
if [[ "$version" =~ ^7.\s* ]];then
  systemctl enable zabbix-agent.service
elif [[ "$version" =~ ^6.\s* ]];then
  chkconfig zabbix-agent on
else
  chkconfig zabbix-agent on
fi
###开启防火墙端口###
firewallmod=`firewall-cmd --stat`
if [[ "$version" =~ ^7.\s* ]] && [[ "$firewallmod" == "running" ]];then
  firewall-cmd --list-ports
  firewall-cmd --permanent --zone=public --add-port=10050/tcp
  firewall-cmd --permanent --zone=public --add-port=10051/tcp
  firewall-cmd --permanent --zone=public --add-port=22/tcp
  firewall-cmd --reload
  firewall-cmd --list-ports
else
  #echo "-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT" >> /etc/sysconfig/iptables
  iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
  iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 10050 -j ACCEPT
  iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 10051 -j ACCEPT
  service iptables save
  service iptables restart
fi
###关闭selinux###
if [[ `getenforce` == "Enforcing" ]] || [[ `cat /etc/selinux/config | grep ^SELINUX=` =~ "enforcing" ]];then
  sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
  setenforce 0
  echo "selinux已关闭"
else
  echo "selinux是关闭状态，不需要关闭！"
fi
###启动zabbix服务###
if [[ "$version" =~ ^7.\s* ]];then
  systemctl start zabbix-agent
  threads=`ps -ef | grep zabbix | grep /etc/zabbix/zabbix_agentd.conf | grep ^zabbix`
  if [[ $threads =~ /etc/zabbix/zabbix_agentd.conf ]];then
    echo "zabbix安装成功！！！"
	ps -ef | grep zabbix
  else
    echo "zabbix进程未启动，请检查配置！"
  fi
else
  service zabbix-agent start
  threads=`ps -ef | grep zabbix | grep /etc/zabbix/zabbix_agentd.conf | grep ^zabbix`
  if [[ $threads =~ /etc/zabbix/zabbix_agentd.conf ]];then
    echo "zabbix安装成功！！！"
	ps -ef | grep zabbix
  else
    echo "zabbix进程未启动，请检查配置！"
  fi
fi
#ctive: active (running)
#ls -al $DIRECTORY | awk '{print $1,$2,$4}'

