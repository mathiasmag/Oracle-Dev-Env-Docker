# Prerequisites

## Install Docker

Choose Docker CE whenever possible.

Installing docker is easy no matter what platform you are on. For platforms and flavors documenhted by docker, just use their [instructions](https://docs.docker.com/install/).

For Red Hat, follow their instructions. They do not install Docker CE, you'll get the older docker-engine. Though it is possible to install Docker CE from Cent OS if you do not need a configuration Red Hat will support.

Oracle Linux install for docker-engine is explained on this [blog](https://blogs.oracle.com/virtualization/install-docker-on-oracle-linux-7-v2). For the things we do here, the part at the end about logging on to the Oracle Container Registry can be skipped.

## Get zip-files for this project and Oracle Docker project.

Either use these commands to download and unzip into the directory you execute them from or follow the steps below to do it 1manually.
```
cd
mkdir devenv
cd devenv
mkdir oracle
mkdir evilape
cd oracle
curl -Lk https://github.com/oracle/docker-images/archive/master.zip --output ~/Downloads/dl.zip;unzip ~/Downloads/dl.zip;rm ~/Downloads/dl.zip
cd ../evilape
curl -Lk https://github.com/mathiasmag/Oracle-Dev-Env-Docker/archive/master.zip --output ~/Downloads/dl.zip;unzip ~/Downloads/dl.zip;rm ~/Downloads/dl.zip
```

## Download necessary files for the builds

Download these and place them in the dockerfiles directory of the unzipped files for this project (Oracle Development Environment).

Grab the latest version/update for each file within the version indicated below.

I recommend putting the files in  software repository directory, I use ~/devenv_src below. This is not required, but makes it easier if you want to rerun the setup at some point.

- [Oracle APEX 19.2](https://www.oracle.com/technetwork/developer-tools/apex/downloads/index.html)
- [Oracle SQLcl 19.4](https://www.oracle.com/technetwork/developer-tools/sqlcl/downloads/index.html)
- [Java Version 8u241 - server-jre-8u<nnn>-linux-x64.tar.gz](https://www.oracle.com/java/technologies/javase-server-jre8-downloads.html)
- [Oracle ORDS 19.2](https://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/index.html)

Assuming this downloads into ~/Downloads, this command can be used to move to the receommended software repository directory.
````
cd ~/Downloads
mv apex_19.2_en.zip sqlcl-19.*.zip server-jre-8u241-linux-x64.tar.gz ords-19.2.*.zip ~/devenv_src

## Build and run 
Follow the [next](BuildAndRun.md) document to build the images and create the containers.
