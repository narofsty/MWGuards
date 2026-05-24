#!/bin/bash
#按小时备份--每个小时创建一个归档
####################################################
#设置配置文件
config_file=/archive/hourly/Files_Backup.txt
#
#设置基础归档文件目的地址
#
basedest=/archive/hourly
#
#获取当前年月日，时间
#
day=$(date +%d)
month=$(date +%m)
year=$(date +%Y)
time=$(date +%H%M)
#
#创建归档目的地址
#
mkdir -p $basedest/$year/$month/$day
#
#创建归档目的文件名
#
destination=$basedest/$year/$month/$day/archive$time.tar.gz
#
#############主程序########################################
#
#检查备份配置文件是否存在
#
if [ -f "$config_file" ] #确保配配置文件存在,存在，什么都不做，继续执行
then                   
    echo
else    #如果不存在，打印错误并退出
    echo
    echo "$config_file 不存在"
    echo "备份没有完成因为找不到配置文件"
    echo
    exit 1
fi 
#
#根据配置文件找到所有文件或者路径的名字
#
file_no=1                   #从配置文件的第一行开始    
#

#
while read file_name          #创建要备份的文件列表
do 
        #确保文件或者路径存在
    if [ -f "$file_name" -o -d "$file_name" ]
    then 
        #如果存在，添加到列表中
        file_list="$file_list $file_name"
    else
        #不存在，返回错误信息
        echo
        echo "$file_name, 不存在"
        echo "显然，我不包含在这个归档中。"
        echo "在配置文件中的 $file_no 行。"
        echo
    fi
#
    file_no=$((file_no + 1)) #一行一行的增加
done < "$config_file"
#
##########################################
#备份文件并进行归档压缩
echo "开始归档中......"
echo
#
tar zcf $destination $file_list 2> /dev/null
#
echo "归档完成"
echo "最终归档文件是：$destination"
echo
#
exit