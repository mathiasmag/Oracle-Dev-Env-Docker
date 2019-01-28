# Build and run the images
Now that the pre-requisites has been completed, we just need to build the images and then start the containers.

## Execute the script to build the images

In the same directory where you put the zip-files, there is a script buildall.sh. It builds all images needed for the dev elopment environment.

Parameters:
- Position 1 - Location of the base directory for the oracle docker project.

for example:
- $ ./buildall.sh ~/ora_dkr
(assuming you created ora_dkr and unzipped the Oracle Docker project in there.)

NOTE: It writes all standard output to buildall.log. It only shows each steps it starts as output to the user. Tail that file if you want to follow how the process goes.

Warnings and errors written to standard error shown up. There should be none. With known exception of these that shows up twice.

```
WARNING: bridge-nf-call-iptables is disabled
WARNING: bridge-nf-call-ip6tables is disabled
```
## Execute the script to create and start the containers

In the same directory where you put the zip-files, there is a script createandstartall.ksh. It takes the needed parameters for creating starting the containers.

Parameters:
- Position 1 - Name of the docker network used by the containers to communicate.
- Position 2 - Directory for volumes where files are stored external to docker containers. Should exist and be empty.
- Position 3 - Password to be used for all created users.
- Position 4 - Port to map traffic to Oracle listener to. It is is 1521 inside the container.
- Position 5 - Port to map traffic to OEM Express to. It is is 5500 inside the container.
- Position 6 - Port to map traffic to ORDS. It is is 8888 inside the container.

It is often easiest to use the same port on your system as is being used in the containers. Unless you want to set up many parallell environments on your system.

NOTE: Currently the certificate presented by OEM is not allowed by Firefox.

NOTE: It writes all standard output to createandstartall.log. It only shows each steps it starts as output to the user. Tail that file if you want to follow how the process goes.

