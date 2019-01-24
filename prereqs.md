# Prerequisites

## Install Docker

Choose Docker CE whenever possible.

Installing docker is easy no matter what platform you are on. For platforms and flavors documenhted by docker, just use their [instructions](https://docs.docker.com/install/).

For Red Hat, follow their instructions. They do not install Docker CE, you'll get the older docker-engine. Though it is possible to install Docker CE from Cent OS if you do not need a configuration Red HAt will support.

Oracle Linux install for docker-engine is explained on this [blog](https://blogs.oracle.com/virtualization/install-docker-on-oracle-linux-7-v2). For the things we do here, the part at the end about logging on to the Oracle Container Registry can be skipped.

## Get zip-files this project and Oracle Docker project.

Either use these commands to download and unzip into the directory you execute them from or follow the steps below to do it manually.
```
mkdir oracle
mkdir evilape
cd oracle
wget -O ~/Downloads/dl.zip  https://github.com/oracle/docker-images/archive/master.zip;unzip ~/Downloads/dl.zip;rm ~/Downloads/dl.zip
cd ../evilape
wget -O ~/Downloads/dl.zip  https://github.com/mathiasmag/Oracle-Dev-Env-Docker/archive/master.zip;unzip ~/Downloads/dl.zip;rm ~/Downloads/dl.zip
```

###Manual steps
Go to thise prjects and click "clone or download" + "Download ZIP"
- [Oracle Developement Environment (this)](https://github.com/mathiasmag/Oracle-Dev-Env-Docker)
- [Oracle Docker Images](https://github.com/oracle/docker-images)

#### Unzip both zip-files

Unzip them anywhere on your machine.

## Download necessary files for the builds

Download these and place them in the dockerfiles directory of the unzipped files for this project (Oracle Development Environment).

Grab the latest version/update for each file within the version indicated below.

- [Oracle XE 18c - Linux x64](https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html)
- [Oracle APEX 18](https://www.oracle.com/technetwork/developer-tools/apex/downloads/index.html)
- [Oracle SQLcl 18](https://www.oracle.com/technetwork/developer-tools/sqlcl/downloads/index.html)
- [Java Version 8 - server-jre-8u<nnn>-linux-x64.tar.gz](https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html)
- [Oracle ORDS 18](https://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/index.html)

## Build and run 
Follow the next document to build the images and create the containers.
