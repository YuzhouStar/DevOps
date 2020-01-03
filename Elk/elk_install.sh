#!/bin/bash
echo "示例安装elk7.x，请确保上传了elasticsearch-7.0.1-linux-x86_64.tar.gz kibana-7.0.1-linux-x86_64.tar.gz logstash-7.0.1.tar.gz"
#创建用户、组
groupadd elk
useradd elk -g elk -p elk
#解压安装包

#如果是上传的整个压缩包，可以用这种简便方式
if [[ -f /home/elk/elk.tar.gz ]];then
  cd /home/elk
  if [[ $? -eq 0 ]];then
    tar -zxvf elk.tar.gz
  fi
else
  mv /root/elk.tar.gz /home/elk/
  if [[ $? -eq 0 ]];then
    cd /home/elk
    tar -zxvf elk.tar.gz
  fi
fi
################
#if [[ -f /home/elk/elasticsearch-7.0.1-linux-x86_64.tar.gz ]];then
#  cd /home/elk
#else
#  mv /root/jdk1.8.tar.gz /root/elasticsearch-7.0.1-linux-x86_64.tar.gz /root/kibana-7.0.1-linux-x86_64.tar.gz /root/logstash-7.0.1.tar.gz /home/elk/
#  cd /home/elk
#fi
#if [[ $? -eq 0 ]];then
#  tar -zxvf elasticsearch-7.0.1-linux-x86_64.tar.gz
#  sleep 5
#fi
#if [[ $? -eq 0 ]];then
#  tar -zxvf kibana-7.0.1-linux-x86_64.tar.gz
#fi
#if [[ $? -eq 0 ]];then
#  tar -zxvf logstash-7.0.1.tar.gz
#fi
#if [[ $? -eq 0 ]];then
#  tar -zxvf jdk1.8.tar.gz
#fi
################
#修改配置文件
#经过查看，这三个包的配置文件都是注释掉的，使用的是默认配置，基本可以直接运行，要自己手动配置也很方便，直接用命令在最后追加或者去掉‘#’注释即可
#因为压缩包里面已经配置了，所以这些配置都要注释掉
#sed -i "/a/b/g" /home/elk/elasticsearch-7.0.1/config/elasticsearch.yml
#elasticsearch
cat <<EOF>> /home/elk/elasticsearch-7.0.1/config/elasticsearch.yml
cluster.name: my-application
node.name: node-1
network.host: 127.0.0.1
http.port: 9200
EOF
cat /home/elk/elasticsearch-7.0.1/config/elasticsearch.yml | grep -v ^$ | grep -v ^#
#kibana
cat <<EOF>> /home/elk/kibana-7.0.1-linux-x86_64/config/kibana.yml
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
kibana.index: ".kibana"
EOF
cat /home/elk/kibana-7.0.1-linux-x86_64/config/kibana.yml | grep -v ^$ | grep -v ^#
#logstash
cat <<EOF>> /home/elk/logstash-7.0.1/config/logstash.yml
node.name: test
http.host: "127.0.0.1"
EOF
cat /home/elk/logstash-7.0.1/config/logstash.yml | grep -v ^$ | grep -v ^#
cat <<EOF> /home/elk/logstash-7.0.1/config/logstash.conf
input {
    file {
        path => "/home/elk/sfw.log"
        start_position => beginning
    }
}
filter {
}
output {
    elasticsearch {
    hosts => "localhost:9200"
    }
}
EOF
cat /home/elk/logstash-7.0.1/config/logstash.conf | grep -v ^$ | grep -v ^#
#删除文件及授权文件设置环境变量
#rm -rf elasticsearch-7.0.1-linux-x86_64.tar.gz kibana-7.0.1-linux-x86_64.tar.gz logstash-7.0.1.tar.gz
chown -R elk:elk /home/elk/
sed -i "s/export PATH/#export PATH/g" /home/elk/.bash_profile
cat <<EOF>> /home/elk/.bash_profile
export JAVA_HOME=/home/elk/jdk1.8
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH
EOF
source /home/elk/.bash_profile
#启动服务
su - elk <<EOF
#elasticsearch:
/home/elk/elasticsearch-7.0.1/bin/elasticsearch -d
#kibana:
nohup /home/elk/kibana-7.0.1-linux-x86_64/bin/kibana &
#logstash:
nohup /home/elk/logstash-7.0.1/bin/logstash -f /home/elk/logstash-7.0.1/config/logstash.conf >> nohup2.out &
#查看服务进程
ps -ef | grep logstash
ps -ef | grep node
ps -ef | grep elasticsearch
exit
EOF
echo "elk安装成功！！！"
