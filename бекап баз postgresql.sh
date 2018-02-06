#!/bin/bash

timed=$(date +%Y-%m-%d-%k-%M)
mountpoint=$(df -h | grep backup)
t="torg_$timed.sql.tgz"
h="him_$timed.sql.tgz"
r="roznitsya_$timed.sql.tgz"
a="accounting_$timed.sql.tgz"

if [ -n "$mountpoint" ]; then

echo "Снимаю дамп баз данных"
sudo -u postgres pg_dump -Fc -U postgres -v -b -f /var/backup/$t torg
sudo -u postgres pg_dump -Fc -U postgres -v -b -f /var/backup/$h him
sudo -u postgres pg_dump -Fc -U postgres -v -b -f /var/backup/$r roznitsya
sudo -u postgres pg_dump -Fc -U postgres -v -b -f /var/backup/$a accounting

echo "Копирую резервные копии в хранилище бекапов"
sudo cp /var/backup/{$t,$h,$r,$a} /mnt/backpgsql/
echo "Удаляю временные файлы"
sudo rm -r /var/backup/*

exit

else

echo "Подключаю хранилище Бекапов"
sudo mount  -t cifs //192.168.1.1/backup/pgsql/ /mnt/backpgsql/ -o username=back,password=backupfstrade,iocharset=utf8,file_mode=0777,dir_mode=0777
echo "Снимаю дамп баз данных"
sudo -u postgres pg_dump -Fc -U postgres -v -b -f /var/backup/$t torg
sudo -u postgres pg_dump -Fc -U postgres -v -b -f /var/backup/$h him
sudo -u postgres pg_dump -Fc -U postgres -v -b -f /var/backup/$r roznitsya
sudo -u postgres pg_dump -Fc -U postgres -v -b -f /var/backup/$a accounting
echo "Копирую резервные копии в хранилище бекапов"
sudo cp /var/backup/{$t,$h,$r,$a} /mnt/backpgsql/
echo "Удаляю временные файлы"
sudo rm -r /var/backup/*
exit
fi
