#!/bin/bash
#read -p "Please input frame code:" frame
frame=$1
fileordir_name=$2
echo $frame
echo $fileordir_name
today=`date +%Y%m%d`
nowtime=`date +%Y%m%d%H%M%S`
echo $today
echo $nowtime
psmsPID=`ps -ef|grep java |grep psms | awk '{print $2}'`
assetsPID=`ps -ef|grep java |grep assets | awk '{print $2}'`
psmspath=`ps -ef|grep java |grep psms | awk '{for(i=1;i<NF;i++){print $i;}}'|grep Dcatalina.home`
assetspath=`ps -ef|grep java |grep assets | awk '{for(i=1;i<NF;i++){print $i;}}'|grep Dcatalina.home`
echo $assetsPID
echo $psmsPID
echo ${psmspath#*=}
echo ${assetspath#*=}
if [[ $assetsPID ]] && [[ $psmsPID ]] && [[ -f ${assetspath#*=}/conf/Catalina/localhost/$frame.xml ]];then
  path=${assetspath#*=}/conf/Catalina/localhost/$frame.xml
  tp=`cat $path | grep docBase`
  echo ${tp}
  a=`echo ${tp#*docBase=\"}`
  cf=`echo ${a%\"*}/`
  echo "正在备份框架包。。。"
  #cp -rp $cf /speedec/backup/$1.war$today/
  if [[ $? -eq 0 ]];then
    #查找文件
    find $cf -name $2 | tee replace_fileordir$today.log
    #查找文件夹
    #find $cf -name $2 -type d| tee replace_fileordir$today.log
    if [[ `cat replace_fileordir$today.log | wc -l` -eq 1 ]];then
      mv $(cat replace_fileordir$today.log) $(cat replace_fileordir$today.log)$date
    elif [[ `cat replace_fileordir$today.log | wc -l` -eq 1 ]];then
      awk '{print NR,$0}' replace_fileordir$today.log
      read "存在多个同名文件，请选择您需要替换的文件准确路径的行号" linenum
      corr_file=`awk 'NR=$linenum {print $0}'`
      mv $corr_file $corr_file$today && cp ./$2 $corr_file
      echo "完成替换！"
    elif [[ `cat replace_fileordir$today.log | wc -l` -eq 0 ]];then
      echo "没有找到可以被替换的文件，请检查后重试"
    fi
  fi 
fi
