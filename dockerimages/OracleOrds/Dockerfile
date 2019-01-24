# LICENSE UPL 1.0
#
# Copyright (c) 2018 EvilApe and/or its affiliates. All rights reserved.
#
# EVILAPE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle ORDS, to be installed together with XE install
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) apex_18.2.zip
#     Download Oracle Application Express. 18.2 or later
#     from https://www.oracle.com/technetwork/developer-tools/apex/downloads/index.htmli
#     Used only to get the images for the /i references
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put the downloaded file in the same directory as this Dockerfile
#   The Oracles image for Rest DAta Services  will need to be created before this image is created. 
# Run: 
#      $ docker build -t evilape/ords:18.3.0-w_images -f Dockerfile .
#
#
# Pull base image
# ---------------
FROM oracle/restdataservices:18.3.0

# Maintainer
# ----------
LABEL Maintainer="Mathias Magnusson <mathias.magnusson@evilape.eu>"

USER root

# Environment variables used by the build
ENV APEX_IMAGE_HOME=/opt/oracle/product
COPY apex_*.zip /tmp
RUN echo "START" && \
    echo "Next command: yum -y install unzip" && \
    yum -y install unzip && \
    echo "Next command: cd /tmp" && \
    cd /tmp && \
    echo "Next command: unzip apex_*.zip" && \
    unzip apex_*.zip && \
    echo "Next command: mv apex/images /opt/oracle/ords/doc_root/i" && \
    mv apex/images /opt/oracle/ords/doc_root/i && \
    echo "Next command: chown -R oracle:dba /opt/oracle/ords/doc_root/i" && \
    chown -R oracle:dba /opt/oracle/ords/doc_root/i && \
    echo "Next command: rm /tmp/apex_*.zip" && \
    rm /tmp/apex_*.zip  && \
    echo "Next command: rm -rf /tmp/apex" && \
    rm -rf /tmp/apex  && \
    echo "DONE"

USER oracle
#Entrypoint and cmd should not be set as we're extending the Oracle "oracle/restdataservices" image and it has it set to what it should be