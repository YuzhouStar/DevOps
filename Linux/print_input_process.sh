#!/bin/bash
function Proceess(){
spa=''
i=0
while [ $i -le 100 ]
do
  read -n1 input
  if [[ $input -eq " " ]];then
    printf "[%-50s] %d%% \r" "$spa" "$i";
    sleep 0.5
    ((i=i+2))
    spa+='#'
  elif [[ $input -eq "\n" ]];then
    continue
    #exit -1
  else
    continue
    #exit -1
  fi
done
echo
}

Proceess