# Oracle Development Environmenmt setup

This repo sets up an Oracle development environment using:
Oracle DB XE 18c
APEX 18.2
ORDS 18.3
SQL CL 18.3

It is based around the Oracle Docker works when possible and then extended to make it work.

In short the Oracle database is built using Oracles setup for a docker image for Oracle XE. It is then extended to install APEX into the preconfigured plug. Then the Oracle Rest Data Services docker image is built from Oracles docker file. It is extended to add the apex images so the APEX development environment is complete for the plug. Lastly a utuility version of SQL Cl is built and a container created to allow it to be used not as a service (as the database and Ords is), but as a command that starts and ends on every call. Resulting in being able to run the command "sql" on the commandline and not deal with docker commnds at all to use the development setup.

