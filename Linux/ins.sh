#!/usr/bin/env bash

#################################
#   this script aims at scanning all
#   of ports in every host
#   and gives the format prints
#################################

#define the source ip
SOURCE_IP=10.2.15.32

#define the net mask
NET_MASK=21

#the utils required
NMAP=`which nmap`

if [ -z "$NMAP" ] ; then
        echo "please install nmap"
        exit 1
fi


#
FILE_DATE=`date +%s`
DIR="$FILE_DATE"
FILE_NAME="$DIR/hosts_$FILE_DATE"
HOSTS_IP="$DIR/hosts_ip_"$FILE_DATE
HOSTS_IP_PORTS="$DIR/host_ip_port_"$FILE_DATE
mkdir $DIR
touch $FILE_NAME $HOSTS_IP $HOSTS_IP_PORTS


#execute the scan with namp reoutput to the file that create above
nmap -sP "$SOURCE_IP/$NET_MASK" >$FILE_NAME


#extracts hosts ip with sed , and write the result to the file named $HOSTS_IP
#
#sed method ,but we use gawk method!!
#
#sed -n -r "/[0-9]{1,3}(\.[0-9]{1,3}){3}/p" hosts_1522218529

gawk '/[0-9]{1,3}(\.[0-9]{1,3}){3}/{print $NF}' $FILE_NAME > $HOSTS_IP   #matche IP format

#now scan ip-host from file HOST_IP
cat $HOST_IP | while read ip
do
        nmap $ip
done > $HOSTS_IP_PORTS
