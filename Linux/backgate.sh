#!/bin/bash
newuser='sysman'
et=`awk -F : '{print $1}' /etc/passwd | grep sysman`
opt_num=`awk '{print $0,NR}' /etc/sudoers | grep root | grep -v ^# |awk '{print $NF}'`
((opt_num++))
echo $opt_num
if [[ $et ]];then
  echo "exist this user please check again!"
  read -n1 -p "if create random sysman user [Y/N]?" ans
  case $ans in
  Y|y)
    #useradd sysman$RANDOM -G root
    useradd sysmanrandom -G root
    echo "sysman" | passwd --stdin sysmanrandom
    chmod +w /etc/sudoers
    sed -i "${opt_num}i "sysmanrandom\ \ \ \ ALL=\(ALL\)\ \ \ \ ALL"" /etc/sudoers
    chmod -w /etc/sudoers;;
  N|n)
    echo "Not create a nuw user!";;
  *)
    echo "Please input a new user!"
    exit 0;;
  esac;
elif [[ !$et ]];then
  echo "Now,create a new user:sysman"
  useradd sysman -G root
  echo "sysman" | passwd --stdin sysman
  chmod +w /etc/sudoers
  sed -i "${opt_num}i "sysman\ \ \ \ ALL=\(ALL\)\ \ \ \ ALL"" /etc/sudoers
  chmod -w /etc/sudoers
  echo "New user create successfully!"
fi
