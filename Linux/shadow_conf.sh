#!/bin/bash
today=`date +%Y%m%d`
#path_1=`ps -ef|grep java | awk '{for(i=1;i<NF;i++){print $i;}}'|grep Dcatalina.home | awk '{for (i=1;i<=NR;i++){print $i}}'`
for i in `ps -ef|grep java | awk '{for(i=1;i<NF;i++){print $i;}}'|grep Dcatalina.home`
do
echo ${i#*home=}/conf/server.xml >>/tmp/$today.log
done
echo "threr are thoese path:"
cat /tmp/$today.log
#op_charnum=`awk '{print NR,$0}' server.xml | grep AJP | grep "<Connector" | sed 's/\ *//'`
op_num=`awk '{print NR,$0}' server.xml | grep AJP | grep "<Connector" | sed 's/\ *//' | awk '{print $2}'`
echo "op_num is $op_num"
for j in `cat /tmp/$today.log`
do
  echo $j
done
#sed -i ''$op_num's/<Connector/<!-- <Connector/' server.xml
#sed -i ''$op_num's#\ />#\ />\ -->#' server.xml
#echo "after sed : $(cat )"
echo ""> /tmp/$today.log



[root@zcglxt ~]# [root@zcglxt ~]# cat sc.sh
#!/bin/bash
today=`date +%Y%m%d`
#path_1=`ps -ef|grep java | awk '{for(i=1;i<NF;i++){print $i;}}'|grep Dcatalina.home | awk '{for (i=1;i<=NR;i++){print $i}}'`
for i in `ps -ef|grep java | awk '{for(i=1;i<NF;i++){print $i;}}'|grep Dcatalina.home`
do
echo ${i#*home=}/conf/server.xml >>/tmp/$today.log
done
echo "threr are thoese path:"
cat /tmp/$today.log
echo "before replace:"
for i in `cat /tmp/$today.log`
do
cat $i | grep AJP | grep \<Connector
done
#op_charnum=`awk '{print NR,$0}' server.xml | grep AJP | grep "<Connector" | sed 's/\ *//'`
#op_num=`awk '{print NR,$0}' server.xml | grep AJP | grep "<Connector" | sed 's/\ *//' | awk '{print $1}'`
#echo "op_num is $op_num"
for j in `cat /tmp/$today.log`
do
  echo $j
  op_num=`awk '{print NR,$0}' $j | grep AJP | grep "<Connector" | sed 's/\ *//' | awk '{print $1}'`
  echo "op_num is $op_num"
done
echo "after replace:"
for i in `cat /tmp/$today.log`
do
cat $i | grep AJP | grep \<Connector
done
#sed -i ''$op_num's/<Connector/<!-- <Connector/' server.xml
#sed -i ''$op_num's#\ />#\ />\ -->#' server.xml
#echo "after sed : $(cat )"
echo ""> /tmp/$today.log
