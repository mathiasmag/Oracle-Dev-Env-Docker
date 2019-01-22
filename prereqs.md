# Prerequisites

## Install Docker

Choose Docker CE whenever possible.

Installing docker is easy no matter what platform you are on. For platforms and flavors documenhted by docker, just use their [instructions](https://docs.docker.com/install/).

For Red Hat, follow their instructions. They do not install Docker CE, you'll get the older docker-engine. Though it is possible to install Docker CE from Cent OS if you do not need a configuration Red HAt will support.

Oracle Linux install for docker-engine is explained on this [blog](https://blogs.oracle.com/virtualization/install-docker-on-oracle-linux-7-v2).

## Get zip-files this project and Oracle Docker project.

Go to thise prjects and click "clone or download" + "Download ZIP"
- [Oracle Developement Environment (this)](https://github.com/mathiasmag/Oracle-Dev-Env-Docker)
- [Oracle Docker Images](https://github.com/mathiasmag/Oracle-Dev-Env-Docker)

## Unzip both zip-files

Unzip them anywhere on your machine.

## Download necessary files for the builds

Download these and place them in the root directory of the unzipped files for this project (Oracle Development Environment).

Grab the latest version/update for each file within the version indicated below.

- [Oracle XE 18c - Linux x64](https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html)
- [Oracle APEX 18](https://www.oracle.com/technetwork/developer-tools/apex/downloads/index.html)
- [Oracle SQLcl 18](https://www.oracle.com/technetwork/developer-tools/sqlcl/downloads/index.html)
- [Java Version 8 - jre-8u<nnn>-linux-x64.tar.gz](https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html)
- [Oracle ORDS 18](https://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/index.html)

## Execute the script to build and start the containers

In the same directory where you put the zip-files, there is a script build_and_run_all.ksh. It takes the needed parameters for creating all images and starting the resulting containers.

Parameters:
Position 1 - Location of the base directory for the oracle focker project.
Position 2 - Directory for volumes where files are stored external to docker containers. Should exist and preferably be empty.
