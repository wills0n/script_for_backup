#!/bin/bash
 


ROPT="-v -az --delete"
 
#Перенос директорий с настройками Zabbix Appache 
rsync $ROPT /etc/zabbix/ /mnt/backup_zabbix/zabbix_server/etc_zabbix
rsync $ROPT /usr/share/zabbix/ /mnt/backup_zabbix/zabbix_server/usr_share_zabbix
rsync $ROPT /etc/httpd/ /mnt/backup_zabbix/zabbix_server/etc_httpd
#rsync $ROPT /etc/letsencrypt/ /backup/zabbix_server/etc_letsencrypt

#Остановка сервиса Zabbix
systemctl stop zabbix-server
sleep 3

#Дамп БД
mysqldump -uzabbix -p31832312 zabbix > /mnt/backup_zabbix/zabbix_server/`date +%d-%m-%Y`.zabbix.sql

#Запуск сервиса Zabbix
service zabbix-server start

#Удаление дампа бд 3-ёх дневной давности
find /mnt/backup_zabbix/zabbix_server/ -name "*.sql" -mtime +1 -exec rm -f {} \;

#Создание архива
tar -czvf /mnt/backup_zabbix/backup_server/`date +%d-%m-%Y`.backup_zabbix.tar.gz  /mnt/backup_zabbix/zabbix_server

#Удаление архива бекапов  более 55 дней давности
find /mnt/backup_zabbix/backup_server/ -name "*.tar.gz" -mtime +50 -exec rm -f {} \;

