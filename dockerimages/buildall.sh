#!/usr/bin/sh
if [ ! -d "$1/docker-images-master" ]; then
  echo 'Parameter 1 needs to be the directory where the oracle docker files were unzipped.'
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

if (( 0 == $(ls apex_*.zip 2>/dev/null | wc -w) )); then
  echo 'The Oracle APEX installation zip-file needs to be present and located in the same directory as this script.'
  exit
fi

if (( 0 == $(ls server-jre-8u*-linux-x64.tar.gz 2>/dev/null | wc -w) )); then
  echo 'The Oracle Java JRE 8 installation zip-file needs to be present and located in the same directory as this script.'
  exit
fi

if (( 0 == $(ls ords-18*.zip 2>/dev/null | wc -w) )); then
  echo 'The Oracle Java JRE 8 installation zip-file needs to be present and located in the same directory as this script.'
  exit
fi

if (( 0 == $(ls sqlcl-18*.zip 2>/dev/null | wc -w) )); then
  echo 'The Oracle SQLcl installation zip-file needs to be present and located in the same directory as this script.'
  exit
fi

echo 'Copying files'
cp oracle-database-xe-18c-1.0-1.x86_64.rpm $ORA_IMAGES_DIR/docker-images-master/OracleDatabase/SingleInstance/dockerfiles/18.4.0/
cp apex_*.zip OracleAPEX
cp apex_*.zip OracleOrds
cp server-jre-8u*-linux-x64.tar.gz $ORA_IMAGES_DIR/docker-images-master/OracleJava/java-8
cp ords-18*.zip  $ORA_IMAGES_DIR/docker-images-master/OracleRestDataServices/dockerfiles
cp sqlcl-18*.zip OracleSqlcl

echo 'Build oracle/database:18.4.0-xe'

# Build the Oracle XE 18.4.0 image
cd $ORA_IMAGES_DIR/docker-images-master/OracleDatabase/SingleInstance/dockerfiles
./buildDockerImage.sh -x -v 18.4.0 > $SCRIPT_DIR/buildall.log

if [ $(docker image ls -q oracle/database:18.4.0-xe | wc -l) == '0' ]; then
    echo 'The build of Oracle XE did not succeed. Exiting.'
    exit
fi

echo 'Build evilape/database:18.4.0-xe_w_apex'

cd $SCRIPT_DIR/OracleAPEX

docker build -t evilape/database:18.4.0-xe_w_apex -f Dockerfile . >> $SCRIPT_DIR/buildall.log

if [ $(docker image ls -q evilape/database:18.4.0-xe_w_apex | wc -l) == '0' ]; then
    echo 'The build of Oracle XE did not succeed. Exiting.'
    exit
fi

echo 'Build oracle/serverjre:8'

cd $ORA_IMAGES_DIR/docker-images-master/OracleJava/java-8

docker build -t oracle/serverjre:8 .>> $SCRIPT_DIR/buildall.log

if [ $(docker image ls -q oracle/serverjre:8 | wc -l) == '0' ]; then
    echo 'The build of Oracle Java JRE 8 did not succeed. Exiting.'
    exit
fi

echo 'Build oracle/restdataservices'

cd $ORA_IMAGES_DIR/docker-images-master/OracleRestDataServices/dockerfiles

./buildDockerImage.sh -i >> $SCRIPT_DIR/buildall.log

if [ $(docker image ls -q oracle/restdataservices | wc -l) == '0' ]; then
    echo 'The build of Oracle ORDS did not succeed. Exiting.'
    exit
fi

cd $SCRIPT_DIR/OracleOrds

#Translation - List all images named orace/restdataservices that has been created since the image just above was built. For those only list the tag.
#The sort and the head -1 should not be needed as it is a matter of seconds, but they are here just in case.
#It is needed as Oracle tags their image based on the version in the install file. This is done to make it work with future versions of the install file.
RET_VER=$(docker image ls --format "{{.Tag}}" --filter "since=evilape/database:18.4.0-xe_w_apex" oracle/restdataservices|sort -r|head -1)

echo "Build evilape/ords:${RET_VER}-w_images"

docker build -t evilape/ords:${RET_VER}-w_images -f Dockerfile --build-arg ORDS_VER=$RET_VER . >> $SCRIPT_DIR/buildall.log

if [ $(docker image ls -q evilape/ords:${RET_VER}-w_images | wc -l) == '0' ]; then
    echo 'The Extention of Oracle ORDS with APEX images did not succeed. Exiting.'
    exit
fi

cd $SCRIPT_DIR/OracleSqlcl

RET_VER=$(ls sqlcl*.zip|cut -f2 -d-|cut -f1-3 -d.)

echo "Build evilape/sqlcl:${RET_VER}"

docker build -t evilape/sqlcl:${RET_VER} --build-arg SQLCL_VER=${RET_VER} . >> $SCRIPT_DIR/buildall.log

if [ $(docker image ls -q evilape/sqlcl:${RET_VER} | wc -l) == '0' ]; then
    echo 'The build of Oracle SQLcl did not succeed. Exiting.'
    exit
fi

echo 'All Images has been built. Use script runandstartall.sh to create and start contianers.'