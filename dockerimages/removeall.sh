#!/usr/bin/sh
if (( 1 < $(docker container ls --filter NAME=OracleOrds --format "{{.Names}}" | wc -l) )); then
  echo 'More than one coantainer for ORDS found. Not supported removal.'
  exit
fi

ORDS_CONTAINER=$(docker container ls -a --filter NAME=OracleOrds --format "{{.Names}}")
DB_CONTAINER=$(docker container ls -a --filter NAME=OracleXE18c --format "{{.Names}}")

NETWORK=$(docker container inspect $ORDS_CONTAINER|grep NetworkMode|cut -f2 -d:|cut -f2 -d\")

ORACLE_LINUX_IMAGE=$(docker image ls -q oraclelinux)
ORACLE_LINUX_IMAGE_NAME=$(docker image ls --format "{{.Repository}}:{{.Tag}}" oraclelinux)
ORACLE_ORDS_IMAGE=$(docker image ls -q oracle/restdataservices)
ORACLE_ORDS_IMAGE_NAME=$(docker image ls --format "{{.Repository}}:{{.Tag}}" oracle/restdataservices)
ORACLE_JRE_IMAGE=$(docker image ls -q oracle/serverjre)
ORACLE_JRE_IMAGE_NAME=$(docker image ls --format "{{.Repository}}:{{.Tag}}" oracle/serverjre)
ORACLE_DB_IMAGE=$(docker image ls -q oracle/database)
ORACLE_DB_IMAGE_NAME=$(docker image ls --format "{{.Repository}}:{{.Tag}}" oracle/database)
EVILAPE_SQLCL_IMAGE=$(docker image ls -q evilape/sqlcl)
EVILAPE_SQLCL_IMAGE_NAME=$(docker image ls --format "{{.Repository}}:{{.Tag}}" evilape/sqlcl)
EVILAPE_ORDS_IMAGE=$(docker image ls -q evilape/ords)
EVILAPE_ORDS_IMAGE_NAME=$(docker image ls --format "{{.Repository}}:{{.Tag}}" evilape/ords)
EVILAPE_DB_IMAGE=$(docker image ls -q evilape/database)
EVILAPE_DB_IMAGE_NAME=$(docker image ls --format "{{.Repository}}:{{.Tag}}" evilape/database)

ORDS_VOLUME=$(docker container inspect $ORDS_CONTAINER|grep Source|cut -f2 -d:|cut -f2 -d\")
DB_VOLUME=$(docker container inspect $DB_CONTAINER|grep Source|cut -f2 -d:|cut -f2 -d\")

echo 'All components of the development environment will now be removed'
echo
echo 'That includes the following:'
echo '  Network:'
echo "    $NETWORK"
echo
echo '  Containers:'
echo "    $ORDS_CONTAINER"
echo "    $DB_CONTAINER"
echo
echo '  Images:'
echo "    $ORACLE_LINUX_IMAGE_NAME"
echo "    $ORACLE_ORDS_IMAGE_NAME"
echo "    $ORACLE_JRE_IMAGE_NAME"
echo "    $ORACLE_DB_IMAGE_NAME"
echo "    $EVILAPE_SQLCL_IMAGE_NAME"
echo "    $EVILAPE_ORDS_IMAGE_NAME"
echo "    $EVILAPE_DB_IMAGE_NAME"
echo
echo '  Volumes:'
echo "    $DB_VOLUME"
echo "    $ORDS_VOLUME"
echo
echo 'NOTE: The volumes will not be removed by the script, you will'
echo '      be asked to do that if you want to remove database files'
echo '      and ORDS-config'
echo
read -p 'Do you want to contine and remove all of the above? (Y/N) ' continue_flg
echo
if [[ $continue_flg != 'Y' ]]; then
  echo 'Aborting removal per user request'
  exit
fi

echo 'Removal continues per user request'

docker container stop $ORDS_CONTAINER > /dev/null 2>&1
docker container stop $DB_CONTAINER   > /dev/null 2>&1
docker container rm $ORDS_CONTAINER   > /dev/null 2>&1
docker container rm $DB_CONTAINER     > /dev/null 2>&1

docker image rm $EVILAPE_SQLCL_IMAGE  > /dev/null 2>&1
docker image rm $EVILAPE_ORDS_IMAGE   > /dev/null 2>&1
docker image rm $EVILAPE_DB_IMAGE     > /dev/null 2>&1
docker image rm $ORACLE_ORDS_IMAGE    > /dev/null 2>&1
docker image rm $ORACLE_JRE_IMAGE     > /dev/null 2>&1
docker image rm $ORACLE_DB_IMAGE      > /dev/null 2>&1
docker image rm $ORACLE_LINUX_IMAGE   > /dev/null 2>&1

docker network rm $NETWORK            > /dev/null 2>&1

if (( 0 == $(docker container ls -a --format {{.Image}} -f NAME=$ORDS_CONTAINER|wc -l) )); then
  echo "Container $ORDS_CONTAINER has been removed"
else
  echo "Container $ORDS_CONTAINER was not removed. Do it manually."
fi

if (( 0 == $(docker container ls -a --format {{.Image}} -f NAME=$DB_CONTAINER|wc -l) )); then
  echo "Container $DB_CONTAINER has been removed"
else
  echo "Container $DB_CONTAINER was not removed. Do it manually."
fi

if (( 0 == $(docker image ls --format {{.Repository}} $ORACLE_LINUX_IMAGE_NAME|wc -l) )); then
  echo "Image $ORACLE_LINUX_IMAGE_NAME has been removed"
else
  echo "Image $ORACLE_LINUX_IMAGE_NAME was not removed. Do it manually."
fi

if (( 0 == $(docker image ls --format {{.Repository}} $ORACLE_ORDS_IMAGE_NAME|wc -l) )); then
  echo "Image $ORACLE_ORDS_IMAGE_NAME has been removed"
else
  echo "Image $ORACLE_ORDS_IMAGE_NAME was not removed. Do it manually."
fi

if (( 0 == $(docker image ls --format {{.Repository}} $ORACLE_JRE_IMAGE_NAME|wc -l) )); then
  echo "Image $ORACLE_JRE_IMAGE_NAME has been removed"
else
  echo "Image $ORACLE_JRE_IMAGE_NAME was not removed. Do it manually."
fi

if (( 0 == $(docker image ls --format {{.Repository}} $ORACLE_DB_IMAGE_NAME|wc -l) )); then
  echo "Image $ORACLE_DB_IMAGE_NAME has been removed"
else
  echo "Image $ORACLE_DB_IMAGE_NAME was not removed. Do it manually."
fi

if (( 0 == $(docker image ls --format {{.Repository}} $EVILAPE_SQLCL_IMAGE_NAME|wc -l) )); then
  echo "Image $EVILAPE_SQLCL_IMAGE_NAME has been removed"
else
  echo "Image $EVILAPE_SQLCL_IMAGE_NAME was not removed. Do it manually."
fi

if (( 0 == $(docker image ls --format {{.Repository}} $EVILAPE_ORDS_IMAGE_NAME|wc -l) )); then
  echo "Image $EVILAPE_ORDS_IMAGE_NAME has been removed"
else
  echo "Image $EVILAPE_ORDS_IMAGE_NAME was not removed. Do it manually."
fi

if (( 0 == $(docker image ls --format {{.Repository}} $EVILAPE_DB_IMAGE_NAME|wc -l) )); then
  echo "Image $EVILAPE_DB_IMAGE_NAME has been removed"
else
  echo "Image $EVILAPE_DB_IMAGE_NAME was not removed. Do it manually."
fi

if (( 0 == $(docker network ls --filter name=$NETWORK --format {{.Name}}|wc -l) )); then
  echo "Network $NETWORK has been removed"
else
  echo "Network $NETWORK was not removed. Do it manually."
fi

echo
echo 'The volumes for database and ORDS needs to be removed too unless you want to keep those files. You can do it with these commands.'
echo
echo "su -c 'rm -rf $ORDS_VOLUME'"
echo "su -c 'rm -rf $DB_VOLUME'"
echo
echo 'Removal is complete. Perform steps recommended above if any. If you want you can then follow the process from the start again.'
echo