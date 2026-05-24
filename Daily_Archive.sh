#!/bin/bash
# 定时备份（归档），通过创建自动化脚本，以备份指定目录并记录数据的旧版本
#功能需求：tar 命令进行备份数据  tar -cf   ,tar 进行压缩 tar -zcf   可以通过 STDERR重定向到 /dev/null 文件中
#压缩的文件命名  .tar.gz    .tgz
#######################################################################################################
#
#获取当前日期
#
today=$(date +%Y%m%d)
#
#设置归档文件名
#
backupFile=archive$today.tar.gz
#
#设置配置文件和目标文件
#
config_file=/archive/Files_To_Backup.txt
destination=/archive/$backupFile
#
#######主要脚本###################################################
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