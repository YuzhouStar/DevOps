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
if [[ $assetsPID ]] && [[ ! $psmsPID ]] && [[ -f ${assetspath#*=}/conf/Catalina/localhost/$frame.xml ]];then
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
      mv ./$2 $(cat replace_fileordir$today.log)
      if [[ $? -eq 0 ]] && [[ `cat /etc/passwd | grep speed | awk -F ':' 'NR==1 {print $1}'` ]];then
        chown speed:speedadmin $(cat replace_fileordir$today.log)
      fi
      if [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "jsp"x ]];then
        echo "jsp文件，不需要重启！"
      elif [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "class"x ]];then
        echo "正在重启tomcat。。。"
        kill -9 $assetsPID
        echo "${assetspath#*=}/bin/startup.sh"
      else
        echo "非class、jsp文件，不重启"
      fi
    elif [[ `cat replace_fileordir$today.log | wc -l` -ge 1 ]];then
      awk '{print NR,$0}' replace_fileordir$today.log
      read -p "存在`cat replace_fileordir$today.log | wc -l`个同名文件,请选择您需要替换的文件准确路径的行号:" linenum
      #read -p "please input linenum:" linenum
      if [[ $? -eq 0 ]];then
        corr_file=`awk 'NR=='"$linenum"' {print $0}' replace_fileordir$today.log`
        #echo $corr_file
        mv $corr_file $corr_file$today
        mv ./$2 $corr_file
        echo "完成替换！$corr_file"
        if [[ $? -eq 0 ]] && [[ `cat /etc/passwd | grep speed | awk -F ':' 'NR==1 {print $1}'` ]];then
          chown speed:speedadmin $(cat replace_fileordir$today.log)
        fi
      fi
      if [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "jsp"x ]];then
        echo "jsp文件，不需要重启！"
      elif [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "class"x ]];then
        echo "正在重启tomcat。。。"
        kill -9 $assetsPID
        echo "${assetspath#*=}/bin/startup.sh"
      else
        echo "非class、jsp文件，不重启"
      fi
    elif [[ `cat replace_fileordir$today.log | wc -l` -eq 0 ]];then
      echo "没有找到可以被替换的文件，请检查后重试"
    fi
  fi
elif [[ ! $assetsPID ]] && [[ $psmsPID ]] && [[ -f ${psmspath#*=}/conf/Catalina/localhost/$frame.xml ]];then
  path=${psmspath#*=}/conf/Catalina/localhost/$frame.xml
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
      mv ./$2 $(cat replace_fileordir$today.log)
      if [[ $? -eq 0 ]] && [[ `cat /etc/passwd | grep speed | awk -F ':' 'NR==1 {print $1}'` ]];then
        chown speed:speedadmin $(cat replace_fileordir$today.log)
      fi
      if [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "jsp"x ]];then
        echo "jsp文件，不需要重启！"
      elif [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "class"x ]];then
        echo "正在重启tomcat。。。"
        kill -9 $psmsPID
        echo "${psmspath#*=}/bin/startup.sh"
      else
        echo "非class、jsp文件，不重启"
      fi
    elif [[ `cat replace_fileordir$today.log | wc -l` -ge 1 ]];then
      awk '{print NR,$0}' replace_fileordir$today.log
      read -p "存在多个同名文件,请选择您需要替换的文件准确路径的行号:" linenum
      #read -p "please input linenum:" linenum
      if [[ $? -eq 0 ]];then
        corr_file=`awk 'NR=='"$linenum"' {print $0}' replace_fileordir$today.log`
        #echo $corr_file
        mv $corr_file $corr_file$today
        mv ./$2 $corr_file
        echo "完成替换！$corr_file"
        if [[ $? -eq 0 ]] && [[ `cat /etc/passwd | grep speed | awk -F ':' 'NR==1 {print $1}'` ]];then
          chown speed:speedadmin $(cat replace_fileordir$today.log)
        fi
      fi
      if [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "jsp"x ]];then
        echo "jsp文件，不需要重启！"
      elif [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "class"x ]];then
        echo "正在重启tomcat。。。"
        kill -9 $psmsPID
        echo "${psmspath#*=}/bin/startup.sh"
      else
        echo "非class、jsp文件，不重启"
      fi
    elif [[ `cat replace_fileordir$today.log | wc -l` -eq 0 ]];then
      echo "没有找到可以被替换的文件，请检查后重试"
    fi
  fi
elif [[ $assetsPID ]] && [[ $psmsPID ]] && [[ -f ${assetspath#*=}/conf/Catalina/localhost/$frame.xml ]];then
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
      mv ./$2 $(cat replace_fileordir$today.log)
      if [[ $? -eq 0 ]] && [[ `cat /etc/passwd | grep speed | awk -F ':' 'NR==1 {print $1}'` ]];then
        chown speed:speedadmin $(cat replace_fileordir$today.log)
      fi
      if [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "jsp"x ]];then
        echo "jsp文件，不需要重启！"
      elif [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "class"x ]];then
        echo "正在重启tomcat。。。"
        kill -9 $assetsPID
        echo "${assetspath#*=}/bin/startup.sh"
      else
        echo "非class、jsp文件，不重启"
      fi
    elif [[ `cat replace_fileordir$today.log | wc -l` -ge 1 ]];then
      awk '{print NR,$0}' replace_fileordir$today.log
      read -p "存在多个同名文件,请选择您需要替换的文件准确路径的行号:" linenum
      #read -p "please input linenum:" linenum
      if [[ $? -eq 0 ]];then
        corr_file=`awk 'NR=='"$linenum"' {print $0}' replace_fileordir$today.log`
        #echo $corr_file
        mv $corr_file $corr_file$today
        mv ./$2 $corr_file
        echo "完成替换！$corr_file"
        if [[ $? -eq 0 ]] && [[ `cat /etc/passwd | grep speed | awk -F ':' 'NR==1 {print $1}'` ]];then
          chown speed:speedadmin $(cat replace_fileordir$today.log)
        fi
      fi
      if [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "jsp"x ]];then
        echo "jsp文件，不需要重启！"
      elif [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "class"x ]];then
        echo "正在重启tomcat。。。"
        kill -9 $assetsPID
        echo "${assetspath#*=}/bin/startup.sh"
      else
        echo "非class、jsp文件，不重启"
      fi
    elif [[ `cat replace_fileordir$today.log | wc -l` -eq 0 ]];then
      echo "没有找到可以被替换的文件，请检查后重试"
    fi
  fi
elif [[ $assetsPID ]] && [[ $psmsPID ]] && [[ -f ${psmspath#*=}/conf/Catalina/localhost/$frame.xml ]];then
  path=${psmspath#*=}/conf/Catalina/localhost/$frame.xml
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
      mv ./$2 $(cat replace_fileordir$today.log)
      if [[ $? -eq 0 ]] && [[ `cat /etc/passwd | grep speed | awk -F ':' 'NR==1 {print $1}'` ]];then
        chown speed:speedadmin $(cat replace_fileordir$today.log)
      fi
      if [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "jsp"x ]];then
        echo "jsp文件，不需要重启！"
      elif [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "class"x ]];then
        echo "正在重启tomcat。。。"
        kill -9 $psmsPID
        echo "${psmspath#*=}/bin/startup.sh"
      else
        echo "非class、jsp文件，不重启"
      fi
    elif [[ `cat replace_fileordir$today.log | wc -l` -ge 1 ]];then
      awk '{print NR,$0}' replace_fileordir$today.log
      read -p "存在多个同名文件,请选择您需要替换的文件准确路径的行号:" linenum
      #read -p "please input linenum:" linenum
      if [[ $? -eq 0 ]];then
        corr_file=`awk 'NR=='"$linenum"' {print $0}' replace_fileordir$today.log`
        #echo $corr_file
        mv $corr_file $corr_file$today
        mv ./$2 $corr_file
        echo "完成替换！$corr_file"
        if [[ $? -eq 0 ]] && [[ `cat /etc/passwd | grep speed | awk -F ':' 'NR==1 {print $1}'` ]];then
          chown speed:speedadmin $(cat replace_fileordir$today.log)
        fi
      fi
      if [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "jsp"x ]];then
        echo "jsp文件，不需要重启！"
      elif [[ $? -eq 0 ]] && [[ "${fileordir_name##*.}"x = "class"x ]];then
        echo "正在重启tomcat。。。"
        kill -9 $psmsPID
        echo "${psmspath#*=}/bin/startup.sh"
      else
        echo "非class、jsp文件，不重启"
      fi
    elif [[ `cat replace_fileordir$today.log | wc -l` -eq 0 ]];then
      echo "没有找到可以被替换的文件，请检查后重试"
    fi
  fi
elif [[ $assetsPID ]] && [[ $psmsPID ]];then
  echo "没有资产采购进程，请启动进程！"
fi
