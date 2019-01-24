# Build and run the images
Now that the pre-requisites has been completed, we just need to build the images and then start the containers.

## Execute the script to build and start the containers

In the same directory where you put the zip-files, there is a script build_and_run_all.ksh. It takes the needed parameters for creating all images and starting the resulting containers.

Parameters:
- Position 1 - Location of the base directory for the oracle docker project.
- Position 2 - Directory for volumes where files are stored external to docker containers. Should exist and be empty.
- Position 3 - Password to be used for all created users.

