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

if ! [[ $6 =~ ^[0-9]+$ ]] ; then
   echo "Parameter 6 should be an integer. It is the port to map 8888 in the ORDS container to."
   exit
fi

SCRIPT_DIR=$(pwd)
NETWORK_NAME=$1
VOLUME_BASE=$2
PASSWORD=$3
LISTENER_PORT=$4
OEM_PORT=$5
ORDS_PORT=$6

DB_VOLUME=$VOLUME_BASE/OracleXE18c
ORDS_VOLUME=$VOLUME_BASE/ords

#mkdir $DB_VOLUME
#chmod 777 $DB_VOLUME

echo 'Starting and creating database with image evilape/database:18.4.0-xe_w_apex'

#1521 Oracle Listener
#5500 OEM Express
#characterset is hardcoded to AL32UTF8 as it allows use of non UTF8 PDBs if needed.
#docker run --name OracleXE18c \
#           -p $LISTENER_PORT:1521 \
#           -p $OEM_PORT:5500 \
#           -e ORACLE_PWD=$PASSWORD \
#           -e ORACLE_CHARACTERSET=AL32UTF8 \
#           -v $DB_VOLUME:/opt/oracle/oradata \
#           --network=$NETWORK_NAME \
#           evilape/database:18.4.0-xe_w_apex > $SCRIPT_DIR/createandstartall.log &

echo 'Waiting for database creation to complete...'

while true ; do
  sleep 5
  grep 'DATABASE IS READY TO USE!' $SCRIPT_DIR/createandstartall.log
  if (( $? == 0 )) ; then
    break
  fi
done

echo 'Database has been successfully created.'

#Translation - List all images named evilape/ords that has been created since the database image just created was built. For those, only list the tag.
#Then sort and grab the first one, but they are here just in case. From that we keep just the version number.
#It is needed as Oracle tags their image based on the version in the install file. This is done to make it work with future versions of the install file.
#It is assumed you want to use the highest version of the images you have.
RET_VER=$(docker image ls --format "{{.Tag}}" --filter "since=evilape/database:18.4.0-xe_w_apex" evilape/ords|sort -r|head -1|cut -f1 -d-)

# Extract the three main digits for version. If it is 18.4.0, return 184.
VER_SUFFIX=$(echo $RET_VER|cut -f1,2 -d.|sed s/\\.//g)

docker run --name OracleOrds${VER_SUFFIX} \
           --network=$NETWORK_NAME \
           -p $ORDS_PORT:8888 \
           -e ORACLE_HOST=OracleXE18c \
           -e ORACLE_PORT=$LISTENER_PORT> \
           -e ORACLE_SERVICE=XEPDB1 \
           -e ORACLE_PWD=$PASSWORD \
           -e ORDS_PWD=$PASSWORD \
           -v $ORDS_VOLUME:/opt/oracle/ords/config/ords \
           evilape/ords:${RET_VER}-w_images