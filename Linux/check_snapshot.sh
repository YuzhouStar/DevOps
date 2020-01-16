版本一
#!/bin/bash
echo "开始检查......"
su - oracle
sqlplus "/as sysdba"<<EOF
set linesize 200
set pagesize 200
spool /etc/zabbix/zabbix-agent.d/scripts/check_snapshot.log
select count(*),to_char(snapshot_date,'YYYY/MM/DD') from sec_assets_update.assets_snapshot where to_char(snapshot_date,'YYYY/MM/DD')='2019/07/31' group by snapshot_date;
spool off
exit
EOF

#版本二：
#!/bin/bash
echo "开始检查......"
su - oracle<<EOF
source /home/oracle/.bash_profile
#export $ORACLE_HOME
sqlplus sec_base/w72g#LhplpIx@192.168.100.110/assets
set linesize 200
set pagesize 200
spool /etc/zabbix/zabbix_agentd.d/scripts/check_snapshot.log
select 'num' || count(*),'date' || to_char(snapshot_date,'YYYY/MM/DD') from sec_assets.assets_snapshot where to_char(snapshot_date,'YYYY/MM/DD')='2019/08/07' group by snapshot_date;
spool off
exit
EOF
exit
source /root/.bash_profile
result=cat /etc/zabbix/zabbix_agentd.d/scripts/check_snapshot.log | grep num | grep date | grep -v from
echo $reslut

#版本三：
#!/bin/bash
echo "开始检查......"
su - oracle
source /home/oracle/.bash_profile
#export $ORACLE_HOME
#VALUE=`sqlplus sec_base/w72g#LhplpIx@192.168.100.110/assets<<EOF
VALUE=`sqlplus /nolog <<EOF
set heading off feedback off pagesize 0 verify off echo off
conn sec_base/w72g#LhplpIx@192.168.100.110/assets
select to_char(snapshot_date,'YYYY/MM/DD') from sec_assets.assets_snapshot where to_char(snapshot_date,'YYYY/MM/DD')='2019/08/07' group by snapshot_date;
exit
EOF`
exit
echo "The number of rows is $VALUE."

#版本四：
#!/bin/bash
echo "开始检查......"
source /home/oracle/.bash_profile
#export $ORACLE_HOME
#VALUE=`sqlplus sec_base/w72g#LhplpIx@192.168.100.110/assets<<EOF
VALUE=`sqlplus -S sec_base_zs/speedit123@192.168.17.112:3366/assets <<EOF
set heading off feedback off pagesize 0 verify off echo off numwidth 8
var snapshot_count varchar2(30)
var snapshot_price varchar2(30)
var snapshot_date varchar2(30)
begin
  select sum(price) into :snapshot_price from sec_assets_zs.assets_snapshot where to_char(snapshot_date,'YYYY/MM/DD')='2019/12/31' group by snapshot_date;
  select count(num) into :snapshot_count from sec_assets_zs.assets_snapshot where to_char(snapshot_date,'YYYY/MM/DD')='2019/12/31' group by snapshot_date;
  select to_char(snapshot_date,'YYYY/MM/DD') into :snapshot_date from sec_assets_zs.assets_snapshot where to_char(snapshot_date,'YYYY/MM/DD')='2019/12/31' group by snapshot_date;
  :snapshot_date:='snapshot_date:'||:snapshot_date;
  :snapshot_count:='snapshot_count:'||:snapshot_count;
  :snapshot_price:='snapshot_price:'||:snapshot_price;
end;
/
print snapshot_date
print snapshot_count
print snapshot_price
exit
EOF`
echo "The number of rows is $VALUE."
