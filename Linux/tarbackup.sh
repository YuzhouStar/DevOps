#!/bin/bash
#today=`date +%Y%m%d%H%M%S`
today=`date +%Y%m%d`
#/bin/tar -g /opt/tsh/snapshot -zcf /opt/tsh/backup_incremental_$DATE.tar.gz /opt/tsh/testtar
#利用tar完成打包备份工作
#method one 利用tar -g参数，第一次备份时生成时间戳文件，下次增量备份，tar回利用时间戳文件比较，这段
#时间修改过的文件才会被打包
mkdir testtar
echo "123" > testtar/test1
echo "123123" > testtar/test2
mkdir testtar/dir1
#先执行完整备份
echo "首先完整备份"
tar -g snapshot -zcf backup_full$today.tar.gz testtar
ls -al testtar/
if [[ $? -eq 0 ]];then
  echo "完整备份完成此时snapshot文件内容可以通过cat snapshot查看"
  echo "此时再进行增量备份测试。。。"
  echo "aaaaa">> testtar/test1
  echo "aaaaa11111">> testtar/test3
  echo "第一次增量备份"
  tar -zcf backup_incremental_1$today.tar.gz testtar
  ls -al testtar/
  echo "77777" > testtar/test1
  echo "6666" > testtar/test2
  echo "第二次增量备份"
  tar -zcf backup_incremental_2$today.tar.gz testtar
fi
if [[ $? -eq 0 ]] && [[ -d "testtar" ]];then
  echo "删除备份文件，恢复。。。"
  ls -al ./
  rm -rf testtar/
#elif [[ $? -eq 0 ]] && [[ ! -d "testtar" ]];then
  echo "恢复第一次完整备份数据"
  tar -zxf backup_full$today.tar.gz
  ls -al testtar/
  cat testtar/test1
  echo "恢复第一次增量备份数据"
  tar -zxf backup_incremental_1$today.tar.gz
  ls -al testtar/
  cat testtar/test1
  cat testtar/test3
  echo "恢复第二次增量备份数据"
  tar -zxf backup_incremental_2$today.tar.gz
  ls -al testtar/
  cat testtar/test1
  cat testtar/test2
fi
