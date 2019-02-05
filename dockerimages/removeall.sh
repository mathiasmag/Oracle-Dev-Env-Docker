#!/usr/bin/sh
if (( 1 < $(docker container ls --filter NAME=OracleOrds --format "{{.Names}}" | wc -l); then
  echo 'More than one coantainer for ORDS found. Not supported removal.'
  exit
fi

#docker container inspect OracleOrds184|grep Source|cut -f2 -d:|cut -f2 -d\"
NETWORK=$docker container inspect OracleOrds184|grep NetworkMode|cut -f2 -d:|cut -f2 -d\")
ORDS_CONTAINER=$(docker container ls --filter NAME=OracleOrds --format "{{.Names}}")
DB_CONTAINER=$(docker container ls --filter NAME=OracleXE18c --format "{{.Names}}")
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

echo 'All components of the development environment will now be removed'
echo
echo 'That includes the following:'
echo '  Network:'
echo "    $NETWORK"
echo
echo '  Containers:'
echo '    $ORDS_CONTAINER'
echo '    $DB_CONTAINER'
echo
echo '  Images:'
echo "    $ORACLE_LINUX_IMAGE_NAME"
echo "    $ORACLE_ORDS_IMAGE_NAME"
echo "    $ORACLE_JRE_IMAGE_NAME"
echo "    $ORACLE_DB_IMAGE_NAME"
echo "    $EVILAPE_SQLCL_IMAGE_NAME"
echo "    $EVILAPE_ORDS_IMAGE_NAME"
echo "    $EVILAPE_DB_IMAGE_NAME"

read -p ' Do you want to contine and remove all of the above? (Y/N)' continue_flg
if [[ $continue_flg != 'Y' ]]; then
  echo 'Aborting removal per user request'
  exit
fi

echo 'Removal continues per user request'