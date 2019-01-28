#!/usr/bin/sh

junk=$(docker network inspect $1 2>&1 >/dev/null)
#Create the docker network for the containers unless it already exists
if (( ! $? == 0 )); then
  docker network create --driver bridge $1 > /dev/null
fi

if [ ! -d "$2" ]; then
  echo 'Parameter 2 needs to be an existing directory. It is where you want datafiles and ORDS-config to be stored.'
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

if ! [[ $4 =~ ^[0-9]+$ ]] ; then
   echo "Parameter 4 should be an integer. It is the port to map 1521 in the database container to."
   exit
fi

if ! [[ $5 =~ ^[0-9]+$ ]] ; then
   echo "Parameter 5 should be an integer. It is the port to map 5500 in the database container to."
   exit
fi

SCRIPT_DIR=$(pwd)
NETWORK_NAME=$1
VOLUME_BASE=$2
PASSWORD=$3
LISTENER_PORT=$4
OEM_PORT=$5

DB_VOLUME=$VOLUME_BASE/OracleXE18c
ORDS_VOLUME=$VOLUME_BASE/ords

mkdir $DB_VOLUME
chmod 777 $DB_VOLUME

echo 'Starting and creating database with image evilape/database:18.4.0-xe_w_apex'

#1521 Oracle Listener
#5500 OEM Express
#characterset is hardcoded to AL32UTF8 as it allows use of non UTF8 PDBs if needed.
docker run --name OracleXE18c \
           -p $LISTENER_PORT:1521 \
           -p $OEM_PORT:5500 \
           -e ORACLE_PWD=$PASSWORD \
           -e ORACLE_CHARACTERSET=AL32UTF8 \
           -v $DB_VOLUME:/opt/oracle/oradata \
           --network=$NETWORK_NAME \
           evilape/database:18.4.0-xe_w_apex > $SCRIPT_DIR/createandstartall.log &

echo 'Waiting foir database creation to complete...'

while true ; do
  sleep 5
  grep 'DATABASE IS READY TO USE!' $SCRIPT_DIR/createandstartall.log
  if (( $? == 0 )) ; then
    break
  fi
done

echo 'Database has been successfully created.'

