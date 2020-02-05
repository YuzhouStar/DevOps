# define
dayofmonth=`date "+%d"`
today=`date "+%Y%m%d"`
source=/speedec/resources
 
# action
cd $backup
 
if [ $dayofmonth -eq 01 ]; then
	if [ ! -f "full$today.tar.gz" ]; then
		rm -rf /backup/resources/snapshot
		tar -g /backup/resources/snapshot -zcf /backup/resources/full$today.tar.gz $source
	fi
else
	if [ ! -f "inc$today.tar.gz" ]; then
		tar -g /backup/resources/snapshot -zcf /backup/resources/inc$today.tar.gz $source
	fi
fi
