[root@swuzc ~]# cat /speedec/sh/resource_bknew.sh
#!/bin/bash
#define
#year=`date +%Y`
dayofyear=`date "+%m%d"`
dayofmonth=`date "+%d"`
#today=`date "+%Y%m%d"`
yesterday=`date +"%Y%m%d" -d "-1 days"`
lastmonth=`date -d "last month" "+%Y%m"`
lastyear=`date -d "last month" "+%Y"`
source=/data1/speed_resources/resources

#action
cd $backup

if [ $dayofyear -eq 0101 ];then
        if [ ! -f "Full$lastyear.tar.gz" ]; then
                rm -rf /data2/backup/resources/snapshot
                tar -g /data2/backup/resources/snapshot -zcf /data2/backup/resources/Full$lastyear.tar.gz $source
                fi
else
        if [ $dayofmonth -eq 01 ]; then
                if [ ! -f "Inc$lastmonth.tar.gz" ]; then
                tar -g /data2/backup/resources/snapshotM -zcf /data2/backup/resources/Inc$lastmonth.tar.gz $source
		find /data2/backup/resources/inc* -type f -mtime +92 -exec rm -f {} \; 
               fi

        fi
        if [ ! -f "inc$yesterday.tar.gz" ]; then
          tar -g /data2/backup/resources/snapshot -zcf /data2/backup/resources/inc$yesterday.tar.gz $source
        fi
        
fi
