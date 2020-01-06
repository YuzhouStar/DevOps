#!/bin/bash
#echo "Please input product code:"
#此脚本可打印资产采购日志，并输出到当前时间的文件中
echo "Please input frame code:"
read frame
echo "开始打印日志。。。"
echo "结束打印请按Ctrl+C"
today=`date +%Y%m%d%H%M%S`
psmsPID=`ps -ef|grep java |grep psms | awk '{print $2}'`
assetsPID=`ps -ef|grep java |grep assets | awk '{print $2}'`
psmspath=`ps -ef|grep java |grep psms | awk '{for(i=1;i<NF;i++){print $i;}}'|grep Dcatalina.home`
assetspath=`ps -ef|grep java |grep assets | awk '{for(i=1;i<NF;i++){print $i;}}'|grep Dcatalina.home`
echo $today
echo $assetsPID
echo $psmsPID
echo ${psmspath#*=}
echo ${assetpath#*=}
if [[ ! $assetsPID ]] && [[ $psmsPID ]] && [[ -f ${psmspath#*=}/conf/Catalina/localhost/$frame.xml ]];then
  path=${psmspath#*=}/conf/Catalina/localhost/$frame.xml
  tp=`cat $path | grep docBase`
  echo ${tp}
  a=`echo ${tp#*docBase=\"}`
  cf=`echo ${a%\"*}/WEB-INF/config/sfw.properties`
  logp=`cat $cf | grep log.path | sed 's/\r//g'`
  lop=`echo ${logp#*=}`
  echo $lop
  tail -f $lop/$frame.log>>$frame$today.log
elif [[ $assetsPID ]] && [[ ! $psmsPID ]] && [[ -f ${assetspath#*=}/conf/Catalina/localhost/$frame.xml ]];then
  path=${assetspath#*=}/conf/Catalina/localhost/$frame.xml
  tp=`cat $path | grep docBase`
  echo ${tp}
  a=`echo ${tp#*docBase=\"}`
  cf=`echo ${a%\"*}/WEB-INF/config/sfw.properties`
  logp=`cat $cf | grep log.path | sed 's/\r//g'`
  lop=`echo ${logp#*=}`
  echo $lop
  tail -f $lop/$frame.log>>$frame$today.log
elif [[ $assetsPID ]] && [[ $psmsPID ]] && [[ -f ${psmspath#*=}/conf/Catalina/localhost/$frame.xml ]];then
  path=${psmspath#*=}/conf/Catalina/localhost/$frame.xml
  tp=`cat $path | grep docBase`
  echo ${tp}
  a=`echo ${tp#*docBase=\"}`
  cf=`echo ${a%\"*}/WEB-INF/config/sfw.properties`
  logp=`cat $cf | grep log.path | sed 's/\r//g'`
  lop=`echo ${logp#*=}`
  echo $lop
  tail -f $lop/$frame.log>>$frame$today.log
elif [[ $assetsPID ]] && [[ $psmsPID ]] && [[ -f ${assetspath#*=}/conf/Catalina/localhost/$frame.xml ]];then
  path=${assetspath#*=}/conf/Catalina/localhost/$frame.xml
  tp=`cat $path | grep docBase`
  echo ${tp}
  a=`echo ${tp#*docBase=\"}`
  cf=`echo ${a%\"*}/WEB-INF/config/sfw.properties`
  logp=`cat $cf | grep log.path | sed 's/\r//g'`
  lop=`echo ${logp#*=}`
  echo $lop
  tail -f $lop/$frame.log>>$frame$today.log
else:
  echo "没有资产采购java进程，请检查服务是否启动"
fi
