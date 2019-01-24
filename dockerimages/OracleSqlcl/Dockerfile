# LICENSE UPL 1.0
#
# Copyright (c) 2018 EvilApe and/or its affiliates. All rights reserved.
#
# EVILAPE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle SQL CL
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) oracle-database-xe-18c-1.0-1.x86_64.rpm
#     Download Oracle Database Express Edition (XE) Release 18.4.0.0.0 (18c) for Linux x64
#     from https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put the downloaded file in the same directory as this Dockerfile
# Run: 
#      $ docker build -t oracle/database:18.4.0-xe -f Dockerfile.xe .
#
#
# Pull base image
# ---------------
FROM oraclelinux:7-slim

# Maintainer
# ----------
MAINTAINER Mathias Magnusson <mathias.magnusson@evilape.eu>

# Environment variables used by the build
ENV ORACLE_HOME=/opt/oracle/product \
    VER=18.3 \
    SOURCEDIR=/source
COPY sqlcl* /tmp
RUN yum -y install unzip && \
    yum -y install java-11-openjdk.x86_64 && \
    mkdir -p $ORACLE_HOME && \
    mkdir -p $SOURCEDIR && \
    cd $ORACLE_HOME && \
    unzip /tmp/sqlcl-${VER}*
ENTRYPOINT ["/opt/oracle/product/sqlcl/bin/sql"]
CMD ["-h"]
#CMD tail -f /dev/null
