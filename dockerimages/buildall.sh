#!/usr/bin/sh
if [ ! -d "$1/docker-images-master" ]; then
  echo 'Parameter 1 needs to be the directory where the oracle docker files were unzipped.'
  exit
fi

if [ ! -d "$2" ]; then
  echo 'Parameter 2 needs to be an existing directory.'
  exit
fi

if (( ! $(ls -A $2| wc -l) == 0)); then
  echo 'Parameter 2 needs to be an empty directory.'
  exit
fi

if (( ${#3} < 4)); then
  echo 'Parameter 3 needs to be a password of at least 4 characters.'
  echo 'No, not very secure, but this is for a personal development environment. You are free to be more secure.'
  exit
fi

if [ ! -x "$(getenforce)" ]; then
  if [ $(getenforce) == 'Enforcing' ]; then
    echo 'SELINUX is active. Disable it temporarily with "setenforce Permissive".'
    echo 'Edit /etc/selinux/config to change its setting. Or configure it to work with Oracle. Your coice...'
    exit
  fi
 fi


SCRIPT_DIR=$(pwd)
ORA_IMAGES_DIR=$1

#mv oracle-database-xe-18c-1.0-1.x86_64.rpm $ORA_IMAGES_DIR/docker-images-master/OracleDatabase/SingleInstance/dockerfiles/18.4.0/
#mv apex_*.zip ords-18*.zip jre-8u*-linux-x64.tar.gz sqlcl-*.zip oracle-database-xe-18c-1.0-1.x86_64.rpm 



#docker network create --driver bridge oracle_isolated_network

echo 'The End'