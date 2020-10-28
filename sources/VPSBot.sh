#!/bin/bash

SRC="sources" && [[ ! -d ${SRC} ]] && mkdir ${SRC}
[[ $(dpkg --get-selections|grep -w "jq"|head -1) ]] || apt-get install jq -y &>/dev/null
[[ -e /etc/texto-bot ]] && rm /etc/texto-bot
LINE="==========================="

# Importando API
source ShellBot.sh
source ${SRC}/menu
source ${SRC}/ayuda
source ${SRC}/cache
source ${SRC}/invalido
source ${SRC}/status
source ${SRC}/reinicio
source ${SRC}/myip
source ${SRC}/id
source ${SRC}/comandos
source ${SRC}/update
source ${SRC}/comandline

# Token del bot
bot_token="$(cat token)"

# Inicializando el bot
ShellBot.init --token "$bot_token" --monitor --return map
ShellBot.username



download_file () {
# shellbot.sh editado linea 3986
#user="$message_document_file_name"
user="server.hc"
[[ ! -d "$HOME/decript" ]] && mkdir "$HOME/decript"
[[ ! -d "$HOME/decript/${chatuser}" ]] && mkdir "$HOME/decript/${chatuser}"

if [[ ! -z $message_text ]]; then
invalido_fun
else

local file_id
          ShellBot.getFile --file_id ${message_document_file_id[$id]}
          ShellBot.downloadFile --file_path "${return[file_path]}" --dir "$HOME/decript/${chatuser}"

var="$(node decript/index.js -f $HOME/decript/${chatuser}/server.hc -k decript/keys.dat)"
echo "$var" >> $HOME/decript/${chatuser}/data.txt
sed -i '/ERROR/d' $HOME/decript/${chatuser}/data.txt
sed -i '/INFO/d' $HOME/decript/${chatuser}/data.txt
#echo "$var" >> $HOME/decript/data.txt

local bot_retorno="$(cat $HOME/decript/${chatuser}/data.txt)"
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "$(echo -ne "$bot_retorno")" \
									#--parse_mode markdown

	     	ShellBot.sendMessage --chat_id ${permited} \
							--text "$(echo "$bot_retorno")" \
							#--parse_mode markdown

rm -rf $HOME/decript/${chatuser}
return 0
fi
}




msj_add () {
	      ShellBot.sendMessage --chat_id ${1} \
							--text "<i>$(echo -e $bot_retor)</i>" \
							--parse_mode html
}

upfile_fun () {
          ShellBot.sendDocument --chat_id ${message_chat_id[$id]}  \
                             --document @${1}
}

invalido_fun () {
local bot_retorno="$LINE\n"
         bot_retorno+="Comando invalido!\n"
         bot_retorno+="$LINE\n"
	     ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "<i>$(echo -e $bot_retorno)</i>" \
							--parse_mode html
	return 0	
}

msj_fun () {
	      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "<i>$(echo -e "$bot_retorno")</i>" \
							--parse_mode html
	return 0
}

# Ejecutando escucha del bot
while true; do
    ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
    for id in $(ShellBot.ListUpdates); do
	    chatuser="$(echo ${message_chat_id[$id]}|cut -d'-' -f2)"
	    echo $chatuser >&2
	    comando=(${message_text[$id]})
	    [[ ! -e "Admin-ID" ]] && echo "null" > Admin-ID
	    permited=$(cat Admin-ID)
	    comand
    done
done
