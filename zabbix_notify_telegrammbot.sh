# cat /usr/lib/zabbix/alertscripts/telegram_bot.sh
#!/bin/bash

TOKEN='533769680:AAEdFm_2g2VAcqy2Mb48zQ5wnRVR0qK8GcA'

if [ $# -ne 3 ] ; then echo 'Error! You must to define three params' && exit 1 ; fi

CHAT_ID="$1"
SUBJECT="$2"
MESSAGE="$3"

# Определяем emoji для темы сообщения
if [[ $SUBJECT == 'PROBLEM' ]]
then
        ICON="\uD83D\uDE31"
elif [[ $SUBJECT == 'OK' ]]
then
        ICON="\uD83D\uDC4C"
else
        ICON="\u26A0"
fi

curl -s --header 'Content-Type: application/json' --request 'POST' --data "{\"chat_id\":\"${CHAT_ID}\",\"text\":\"$ICON ${SUBJECT}\n${MESSAGE}\"}" "https://api.telegram.org/bot${TOKEN}/sendMessage" | grep -q '"ok":false,'

