#!/bin/sh

CONFIG="${HOME}/.kr_conf"


if [ ! -f "$CONFIG" ]; then
cat << 'eof' > "$CONFIG"
# kr_conf
# kmrror configuration file
#
# WARNING: SUCCESS, FAILED and ON_* variables contain shell commands.
# Be careful when editing this file.


# Actions executed when commands succeed or fail.
#
# SUCCESS:
#   Executed when a command finishes successfully (exit code 0).
#
# FAILED:
#   Executed when a command fails and no custom action exists.


# Custom actions based on exit codes.
#
# The format is:
#
# ON_EXIT_CODE='command'
#
# Example:
#
# ON_127='your command here'
#
# Exit codes:
#
# 0    Command completed successfully
# 1    General error
# 2    Invalid usage
# 126  Permission denied
# 127  Command not found
# 130  Command interrupted by user
#
#
# Available variables:
#
# SUCCESS
#   Action for successful commands.
#
# FAILED
#   Default action for failed commands.
#
# ON_CODE
#   Custom action for a specific exit code.
#
# Example:
#
# ON_127='custom action' 

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

if [ "$codigo" -ne 0 ]; then
    acao=$(eval "printf '%s' \"\${ON_$codigo}\"")

    if [ -n "$acao" ]; then
        eval "$acao"
    fi
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



mostrar_erro()
{
    case "$1" in
        127) echo "Command not found" ;;
        126) echo "Permission denied: cannot execute file" ;;
        130) echo "Command interrupted by user (Ctrl+C)" ;;
        139) echo "Segmentation fault" ;;
        *) echo "Unknown error (exit code: $1)" ;;
    esac
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

