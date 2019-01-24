# LICENSE UPL 1.0
#
# Copyright (c) 2018 EvilApe and/or its affiliates. All rights reserved.
#
# EVILAPE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle APEX, to be installed in an XE install
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) apex_18.2.zip
#     Download Oracle Application Express. 18.2 or later
#     from https://www.oracle.com/technetwork/developer-tools/apex/downloads/index.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put the downloaded file in the same directory as this Dockerfile
#   The database Oracles image creates will be created upon run before the APEX-install i conducted. 
# Run: 
#      $ docker build -t evilape/database:18.4.0-xe_w_apex -f Dockerfile .
#
#
# Pull base image
# ---------------
FROM oracle/database:18.4.0-xe

# Maintainer
# ----------
LABEL Maintainer="Mathias Magnusson <mathias.magnusson@evilape.eu>"

# Environment variables used by the build
ENV APEX_HOME=/opt/oracle/product 
COPY apex_*.zip /tmp
COPY 0* /opt/oracle/scripts/setup/
RUN echo "START" && \
    echo "Next command: yum -y install unzip" && \
    yum -y install unzip && \
    echo "Next command: mkdir -p $APEX_HOME" && \
    mkdir -p $APEX_HOME && \
    echo "Next command: cd $APEX_HOME" && \
    cd $APEX_HOME && \
    echo "Next command: unzip /tmp/apex_*.zip" && \
    unzip /tmp/apex_*.zip && \
    echo "Next command: chown -R oracle:oinstall apex" && \
    chown -R oracle:oinstall apex && \
    echo "Next command: rm /tmp/apex_*.zip" && \
    rm /tmp/apex_*.zip  && \
    echo "Next command: mv /opt/oracle/scripts/setup/01_install_apex.sql $APEX_HOME/apex" && \
    mv /opt/oracle/scripts/setup//01_install_apex.sql $APEX_HOME/apex && \
    echo "Next command: mv /opt/oracle/scripts/setup/04_install_apex.sql $APEX_HOME/apex" && \
    mv /opt/oracle/scripts/setup/04_apex_rest_config.sql $APEX_HOME/apex && \
    echo "DONE"
#Entrypoint and cmd should not be set as we're extending the Oracle XE image and it has it set to aht it should be
#ENTRYPOINT ["/opt/oracle/product/sqlcl/bin/sql"]
#CMD ["-h"]mathias