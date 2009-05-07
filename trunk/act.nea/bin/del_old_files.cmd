rem 操作说明：
rem 修改 e:/act/home 为指定存放用户文件的目录，-mtime +7 表示7天前 -type f表示普通文件 -exec 表示执行操作, rm 是删除操作
rem 此命令可配置到windows的任务中执行
rem 需要用到find.exe rm.exe 请都拷贝到windows\system32目录下
e:\act\bin\find e:/act/home -mtime +7 -type f -exec rm "{}" ";"