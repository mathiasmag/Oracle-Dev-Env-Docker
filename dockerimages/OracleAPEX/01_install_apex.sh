#!/bin/sh
cd $APEX_HOME/apex
su -p oracle -c "$ORACLE_HOME/bin/sqlplus / as sysdba @01_install_apex"