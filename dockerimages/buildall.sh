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
  echo 'Parameter 2 needs to be an empty directory. It is where you want datafiles and ORDS-config to be stored.'
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
    echo 'Edit /etc/selinux/config to change its setting. Or configure it to work with Oracle. Your choice...'
    exit
  fi
 fi


SCRIPT_DIR=$(pwd)
ORA_IMAGES_DIR=$1

if [ ! -f "oracle-database-xe-18c-1.0-1.x86_64.rpm" ]; then
  echo 'The Oracle installation file for XE (oracle-database-xe-18c-1.0-1.x86_64.rpm) needs to be present and located in the same directory as this script.'
  exit
fi

if [ ! -f "apex_*.zip" ]; then
  echo 'The Oracle APEX installation zip-file needs to be present and located in the same directory as this script.'
  exit
fi

cp oracle-database-xe-18c-1.0-1.x86_64.rpm $ORA_IMAGES_DIR/docker-images-master/OracleDatabase/SingleInstance/dockerfiles/18.4.0/
cp apex_*.zip OracleAPEX
#mv  ords-18*.zip jre-8u*-linux-x64.tar.gz sqlcl-*.zip oracle-database-xe-18c-1.0-1.x86_64.rpm 

# Build the Oracle XE 18.4.0 image
cd $ORA_IMAGES_DIR/docker-images-master/OracleDatabase/SingleInstance/dockerfiles
./buildDockerImage.sh -x -v 18.4.0

if [ $(docker image ls -q oracle/database:18.4.0-xe | wc -l) == '0' ]; then
    echo 'The build of Oracle XE did not succeed. Exiting.'
    exit
fi

cd $SCRIPT_DIR/OracleAPEX

docker build -t evilape/database:18.4.0-xe_w_apex -f Dockerfile .

#docker network create --driver bridge oracle_isolated_network

echo 'The End'