#!/bin/bash
# Usage:
# init.sh -u user -p password

USERNAME=user PASSWORD=password DEBUG=n

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  -u | --username)
    USERNAME="$2"
    shift # past argument
    shift # past value
    ;;
  -p | --password)
    PASSWORD="$2"
    shift # past argument
    shift # past value
    ;;
  -d | --debug)
    DEBUG=y
    shift # past argument
    ;;
  *)                   # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift              # past argument
    ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ ${DEBUG} == "y" ]]; then
  echo "USERNAME  = ${USERNAME}"
  echo "PASSWORD  = ${PASSWORD}"
  echo "DEBUG     = ${DEBUG}"
  set -x
fi

useradd "${USERNAME}"
echo "${USERNAME}:${PASSWORD}" | chpasswd
mkdir "/home/${USERNAME}"
chmod go-rx /usr/bin/passwd