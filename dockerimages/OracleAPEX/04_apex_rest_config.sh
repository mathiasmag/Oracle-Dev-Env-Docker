#!/bin/sh
cd $APEX_HOME/apex
su -p oracle -c "$ORACLE_HOME/bin/sqlplus / as sysdba @04_apex_rest_config"