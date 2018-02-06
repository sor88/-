tu="Подключение_клиента_KerioVPN"

kes=$(zenity --list --text="What do you think about your PC?" \
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
sudo service kerio-kvc start
echo "Подключение клиента KerioVPN";
fi

if [ $kes = Отключение_Kerio_VPN_клиент ]; then
sudo service kerio-kvc stop
echo "Отключение Kerio VPN клиент";
fi

if [ $kes = Установить_Kerio_VPN_клиент  ]; then
wget -P /tmp/ http://download.kerio.com/eu/dwn/kerio-control-vpnclient-linux.deb
sleep 1
sudo dpkg -i --force-architecture --force-depends kerio-control-vpnclient-linux.deb
sudo dpkg-reconfigure kerio-control-vpnclient
echo "Установить Kerio VPN клиент";
fi

if [ $kes = Удалить_Пакет_Kerio_VPN_клиент ]; then
sudo dpkg -r kerio-control-vpnclient;
sleep 1
echo "Удалить Пакет Kerio VPN клиент";
fi

exit


