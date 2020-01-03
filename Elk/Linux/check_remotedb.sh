#版本一：
#!/bin/bash
today=`date +%Y%m%d`
ip=`df -h | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | awk 'NR==1{print $1}'`
remote_backup_dir=`df -h | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}.*' | awk 'NR==1{print $6}'`
if [[ -d ${remote_backup_dir}/oracle ]] && [[ `du -sh -m $remote_backup_dir/oracle/* | grep $today | grep .tar | awk 'NR==1{print $1}'` -ge 10 ]] && [[ `du -sh -m $remote_backup_dir/oracle/* | grep $today | grep .tar | awk 'NR==1{print $1}'` ]];then
  echo "ok"
elif [[ ! -d ${remote_backup_dir}/oracle ]] && [[ `du -sh -m $remote_backup_dir/* | grep $today | grep .tar | awk 'NR==1{print $1}'` -ge 10 ]] && [[ `du -sh -m $remote_backup_dir/* | grep $today | grep .tar | awk 'NR==1{print $1}'` ]];then
  echo "ok"
else
  echo "sorry"
fi


#版本二：
#!/bin/bash
today=`date +%Y%m%d`
ip=`df -h | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | awk 'NR==1{print $1}'`
remote_backup_dir=`df -h | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}.*' | awk 'NR==1{print $6}'`
if [[ -d ${remote_backup_dir} ]];then
  if [[ -d ${remote_backup_dir}/oracle/ ]] && [[ `du -sh -m ${remote_backup_dir}/oracle/* | grep $today | grep .tar | awk 'NR==1{print $1}'` -ge 10 ]] && [[ `du -sh -m ${remote_backup_dir}/oracle/* | grep $today | grep .tar | awk 'NR==1{print $1}'` ]];then
    echo "1"
  elif [[ ! -d ${remote_backup_dir}/oracle/ ]] && [[ `du -sh -m ${remote_backup_dir}/* | grep $today | grep .tar | awk 'NR==1{print $1}'` -ge 10 ]] && [[ `du -sh -m ${remote_backup_dir}/* | grep $today | grep .tar | awk 'NR==1{print $1}'` ]];then
    echo "1"
  else
    echo "0"
  fi
else
  #echo "没有异地备份！"
  echo "0"
  echo "请删除本脚本，避免误判"
fi
