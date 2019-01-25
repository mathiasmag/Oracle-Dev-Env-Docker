#!/usr/bin/sh

junk=$(docker network inspect $1 2>&1 >/dev/null)
#Create the docker network for the containers unless it already exists
if (( ! $? == 0 )); then
  docker network create --driver bridge oracle_isolated_network
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

mkdir $2/OracleXE18c

#1521 Oracle Listener
#5500 OEM Express
#characterset is hardcoded to AL32UTF8 as it allows use of non UTF8 PDBs if needed.
docker run --name OracleXE18c \
           -p $4:1521 \
           -p $5:5500 \
           -e ORACLE_PWD=$3 \
           -e ORACLE_CHARACTERSET=AL32UTF8 \
           -v $2/OracleXE18c:/opt/oracle/oradata \
           --network=$1 \
           evilape/database:18.4.0-xe_w_apex