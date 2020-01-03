#!/bin/bash
today=`date +%Y%m%d`
backup_dir=/backup/oracle/
num=`ls -l $backup_dir | grep .tar | wc -l`
num_today=`ls -l $backup_dir | grep .tar | grep $today | wc -l`
#echo $num
size=`du -sh -m  /backup/oracle/* | grep tar | awk '{print $1}'`
size_today=`du -sh -m  /backup/oracle/* | grep tar | grep $today |awk '{print $1}'`
if [[ $num_today -ge 1 ]] && [[ $size_today -ge 10 ]] && [[ $((10#$(date +%d))) -gt 15 ]];then
  #echo "当天备份正常"
  j=0
  for((i=$today;i>$today-2;i--));
  do
  if [[ `du -sh -m  /backup/oracle/* | grep tar | grep $i | awk 'NR==1{print $0}' | awk '{print $1}'` -ge 10 ]] && [[ `du -sh -m  /backup/oracle/* | grep tar | grep $i | awk 'NR==1{print $0}'` =~ $i ]];then
    #echo "ok"
    let j++
  fi
  done
  if [[ $j -ge 2 ]];then
    echo 1
  else
    echo 0
  fi
elif [[ $num_today -ge 1 ]]  && [[ $size_today -ge 10 ]] && [[ $((10#$(date +%d))) -le 15 ]];then
  k=0
  #for((t=1;t<16;t++));
  for file in `find /backup/oracle/* -type f -mtime -2 | sed 's#.*/##' | sort -r`;
  do
  #if [[ `du -sh -m  /backup/oracle/* | grep tar | sort -r | head -15 | awk "NR==$t{print \$1}"` -ge 50 ]] && [[ `du -sh -m  /backup/oracle/* | grep tar | sort -r | head -15 | awk "NR==$t{print \$1}"` ]];then
  #if [[ `du -sh -m  /backup/oracle/* | grep tar | sort -r | head -15 | awk "NR==$t{print}" | awk '{print $1}'` -ge 50 ]] && [[ `du -sh -m  /backup/oracle/* | grep tar | sort -r | head -15 | awk "NR==$t{print}" | awk '{print $1}'` ]];then
  #此行报错if [[ `du -sh -m  /backup/oracle/* | grep tar | sort -r | find -type f -mtime -15 | awk "NR==$t{print}" | awk '{print $1}'` -ge 50 ]] && [[ `du -sh -m  /backup/oracle/* | grep tar | sort -r | find -type f -mtime -15 | awk "NR==$t{print}" | awk '{print $1}'` ]];then
  if [[ `du -sh -m  /backup/oracle/* | grep $file | awk '{print $1}'` -ge 10 ]] && [[ `du -sh -m  /backup/oracle/* | grep $file | awk '{print $1}'` ]];then
    #tar -tf $file >>/dev/null
	#if [[ $? -eq 0 ]];then
    let k++
	#fi
  fi
  done
  if [[ $k -ge 2 ]];then
    echo 1
  else
    echo 0
  fi	
else
  #echo "备份异常"
  echo 0
fi
#for s in $size
#do
#  if [[ $num -gt 15 ]] && [[ $s -gt 50 ]];then
#    echo "ok"
#  else
#    echo "sorry"
#  fi
#done



#echo "UserParameter=backupfile.catalog,/etc/zabbix/zabbix_agentd.d/scripts/check_file.sh" >>/etc/zabbix/zabbix_agentd.conf
#if [[ `du -sh -m  /backup/oracle/* | grep tar | sort -r | head -15 | awk "NR==$t{print}" | awk '{print $1}'` -ge 50 ]] && [[ `du -sh -m  /backup/oracle/* | grep tar | sort -r | head -15 | awk "NR==$t{print}" | awk '{print $1}'` ]];then
