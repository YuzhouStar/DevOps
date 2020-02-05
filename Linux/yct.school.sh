[root@ccitapp ~]# crontab -l
*/30 * * * * /tmp/yct.school.sh
0 5 * * * /speedec/sh/resources_backup.sh
[root@ccitapp ~]# cat /tmp/yct.school.sh
#!/bin/bash
school_code="ccit"

base="/tmp/"

path="/www/application/"
#path="/tmp/"

cd $base

url="http://www.yuncaitong.cn/yct.school"

echo $school_code
echo $path
echo $url


eval `cat ./version`

rm ./yct.school.version
wget $url/yct.school.version
remote_school_version=`cat ./yct.school.version|awk '{printf $0}' `

rm ./$school_code.version
wget $url/custom/$school_code.version
remote_school_custom_version=`cat ./$school_code.version|awk '{printf $0}' `

# yct.school
if test $school_version -eq $remote_school_version
then
    echo 'skip yct.school.'
else
        rm ./yct.school.zip
        wget $url/yct.school.zip
        unzip -o ./yct.school.zip -d $path/yct.school/
fi

# yct.school.custom
if test $school_custom_version -eq $remote_school_custom_version
then
    echo 'skip yct.school.custom.'
else
        rm ./$school_code.zip
        wget $url/custom/$school_code.zip
        unzip -o $school_code.zip -d $path/yct.school.custom/
fi

if test $school_version -eq $remote_school_version -a $school_custom_version -eq $remote_school_custom_version ; then
        echo "skip version."
else
        echo "flush version."

        echo "school_version=$remote_school_version" > ./version
        echo "school_custom_version=$remote_school_custom_version" >> ./version
fi

echo "upgrade complete."

# deprecated not safe.
#wget $url/yct.school.upgrade.sh
#chmod +x ./yct.school.upgrade.sh
