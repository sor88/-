#!/bin/bash 
testzenity=$(sudo apt list | grep zenity-common)
if [ -n $"testzenity" ]; then
echo start #	zenity --info --timeout=1 --width=300 --title="Установка zenity" --text="Zenity уже установлен"
else
	zenity --info --timeout=1 --width=300 --title ="Установка Zenity" --text="Требуется установка графического интерфейса командной строки"
sudo apt install zenity
fi
tu="Подключение_клиента_KerioVPN"

kes=$(zenity --list --text="Подключение kerio VPN" \
    --radiolist --column "Pick" --column "Opinion" --width 350\
    TRUE "Выход" \
    FALSE $tu \
    FALSE "Отключение_Kerio_VPN_клиент" \
    FALSE "Изминение_настроек_подключения_Kerio_VPN" \
    FALSE "Установить_Kerio_VPN_клиент" \
    FALSE "Удалить_Пакет_Kerio_VPN_клиент" \
    --height=350)
echo $kes
#echo $?

if [ $kes = Выход ]; then
echo "работает"
#else
#echo "Отмена";
fi

if [ $kes = $tu ]; then
gksu service kerio-kvc start
echo "Подключение клиента KerioVPN";
fi

if [ $kes = Отключение_Kerio_VPN_клиент ]; then
gksu service kerio-kvc stop
echo "Отключение Kerio VPN клиент";
fi

if [ $kes = Изминение_настроек_подключения_Kerio_VPN ]; then
zenity --info --width=350 --height=350 --title ="Изминение настроек Kerio VPN клиента" --text="Для изминение настроек Kerio VPN выполните в терминале: sudo dpkg-reconfigure kerio-control-vpnclient"
echo "Изминение_настроек_подключения_Kerio_VPN";
fi

if [ $kes = Установить_Kerio_VPN_клиент  ]; then
wget -P /tmp/ http://download.kerio.com/eu/dwn/kerio-control-vpnclient-linux.deb
sleep 1
gksu dpkg -i --force-architecture --force-depends kerio-control-vpnclient-linux.deb
gksu dpkg-reconfigure kerio-control-vpnclient
echo "Установить Kerio VPN клиент";
fi

if [ $kes = Удалить_Пакет_Kerio_VPN_клиент ]; then
gksu dpkg -r kerio-control-vpnclient;
sleep 1
echo "Удалить Пакет Kerio VPN клиент";
fi

exit


