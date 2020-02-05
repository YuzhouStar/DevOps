UNIVERSITY="cque"
DBUSER="sec_base"
DBPWD="Cque_wsxzaq_db"
NLS_LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK"
export NLS_LANG
PATH=/oracle/product/11.2.0/db_1/bin:/usr/sbin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/oracle/bin
export PATH
ORACLE_BASE=/oracle
ORACLE_HOME=/oracle/product/11.2.0/db_1
ORACLE_SID=assets
LD_LIBRARY_PATH=/oracle/product/11.2.0/db_1/lib:/lib:/usr/lib:/usr/lib64
export  ORACLE_BASE ORACLE_HOME ORACLE_SID LD_LIBRARY_PATH
DM=`date +%Y%m%d%H%M%S`

TAR_FILE="/backup/oracle/$UNIVERSITY-db-$DM.tar"

expdp $DBUSER/$DBPWD DIRECTORY=expdp_dir SCHEMAS=sec_base COMPRESSION=ALL DUMPFILE=sec_base.dmp logfile=sec_base.log EXCLUDE=TABLE:\"IN \(\'SYSTEM_LOG\',\'SYSTEM_EXCEPTION\'\)\" 
expdp $DBUSER/$DBPWD DIRECTORY=expdp_dir SCHEMAS=sec_bl_assets COMPRESSION=ALL DUMPFILE=sec_bl_assets.dmp logfile=sec_bl_assets.log
expdp $DBUSER/$DBPWD DIRECTORY=expdp_dir SCHEMAS=sec_assets COMPRESSION=ALL DUMPFILE=sec_assets.dmp logfile=sec_assets.log
expdp $DBUSER/$DBPWD DIRECTORY=expdp_dir SCHEMAS=sec_psms COMPRESSION=ALL DUMPFILE=sec_psms.dmp logfile=sec_psms.log
expdp $DBUSER/$DBPWD DIRECTORY=expdp_dir SCHEMAS=sec_contract COMPRESSION=ALL DUMPFILE=sec_contract.dmp logfile=sec_contract.log

tar zcvf $TAR_FILE /backup/expdp_dir/*
rm -f /backup/expdp_dir/*

find /backup/oracle     -type f -mtime +30 -exec rm -f {} \;