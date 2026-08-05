#!/bin/sh

CONFIG="${HOME}/.kr_conf"


if [ ! -f "$CONFIG" ]; then
cat << 'eof' > "$CONFIG"
# kr_conf
# WARNING: SUCCESS and FAILED contain shell commands

# This file is automatically created by kmrror.
# It is used to customize actions when a command succeeds or fails.

# To configure actions, use the SUCCESS variable for successful commands
# and the FAILED variable for failed commands.
eof
fi 

. "$CONFIG"

error() {

printf "${red}[ ERROR ] command failed${reset}\n"
}



checar() {
"$@"
codigo=$? 

if [ "$codigo" -eq 0 ]; then
printf "${green}[ ok ] command completed${reset}\n"
eval "$SUCCESS"
else 
error
eval "$FAILED"
fi
}

help() {
    printf "kmrror - ferramenta de diagnóstico\n\n"
    printf "Uso: kmrror [opção]\n\n"
    printf "Opções:\n"
    printf "  -h, --help      Mostra ajuda\n"
    printf "  -v, --version   Mostra versão\n"
    printf "  check           Verifica sistema\n"
}

reset="\033[0m"
red="\033[1;31m"
green="\033[1;32m"


if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    help
    exit 0
fi

if [ "$1" = "-v" ] || [ "$1" = "--version" ]; then
    printf "kmrror 0.1.0\n"
    exit 0
fi


checar "$@"

