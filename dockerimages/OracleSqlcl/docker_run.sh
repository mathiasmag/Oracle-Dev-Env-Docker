#!/bin/sh
ocker run --rm --network=oracle_isolated_network -v /home/mathias/dkr/OracleSqlcl:/source evilape/sqlcl:18.3 sys/EvilApe@//OracleXE18c:1521/XE as sysdba @/source/test.sql
