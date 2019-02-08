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

In the same directory where you put the zip-files, there is a script createandstartall.sh. It takes the needed parameters for creating starting the containers.

Parameters:
- Position 1 - Name of the docker network used by the containers to communicate.
- Position 2 - Directory for volumes where files are stored external to docker containers. Should exist and be empty.
- Position 3 - Password to be used for all created users.
- Position 4 - Port to map traffic to Oracle listener to. It is is 1521 inside the container.
- Position 5 - Port to map traffic to OEM Express to. It is is 5500 inside the container.
- Position 6 - Port to map traffic to ORDS. It is is 8888 inside the container.

For example.
- $ ./createandstartall.sh oracle_nw ~/dkr_data/ EvilApe 1521 5500 8888

It is often easiest to use the same port on your system as is being used in the containers. Unless you want to set up many parallell environments on your system.

NOTE: Currently the certificate presented by OEM is not allowed by Firefox.

NOTE: It writes all standard output to createandstartall.log. It only shows each steps it starts as output to the user. Tail that file if you want to follow how the process goes.

## Remove the environment

If you want to recreate the whole environment, just run the script removeall.sh without any parameters.

$ ./removeall.sh

It will show all things it will remove and prompt the user before continuing. It ends with giving commands to remove the volumes for database and ords. That is just so the user removes those files themselves. Everything in docker can be recreated by the above, but if dsatabase or ords-config has been changed then it removes things that cannot be recreated.

## What can you do now with your brand new development environment?

You have an environment with: 
- Oracle Database XE 18c 
  - CDB - Container database - XE
  - PDB - Pluggable database - XEPDB1
  - Application Express installed in the PDB
- Oracle Rest Data Services
  - Configured for APEX access to PDB1
  - ADMIN user for the APEX-instance with the password you provided
  - APEX images deployed
- SQLCL
  - Created to be used as an executable and not a service in docker

### Different ways to use it
#### SQLPLUS/SQLCL installed on your machine
Just as you always do here are some examples.

```
$ sqlplus sys/<your password>@//localhost:1521/XE as sysdba
$ sqlplus system/<your password>@//localhost:1521/XE
$ sqlplus pdbadmin/<your password>@//localhost:1521/XEPDB1
```

Though, why have local installs of it when you are using docker? Still, as seen, you can if you want to.

#### SQL*PLUS in interactive mode
Here we will use the SQL*PLUS that comes with the database. Not the purist way as the database container is used for a second use, ut it does the trick.

```
$ docker exec -ti OracleXE18c sqlplus sys/<your password>@//localhost:1521/XE as sysdba
```

Not that the connectionstring is identical to what we use in the section above for SQL*PLUS installed oin your system.

Still, why use SQL*PLUS at all when SQLcl exists?

#### SQLcl in interactive mode

If you want a SQL prompt to do some database work, use this command:
- $ docker run --rm --network=<network name> -it evilape/sqlcl:18.4.0 sys/<your password>@//OracleXE18c:1521/XE as sysdba

NOTE: You may need to change 18.4.0 to a different version if you have installed another version of SQLcl.

You get logged in and can do your work. When you exit the container is removed so you can just run again. Just like normal.

To simplify this, read on.

#### SQLcl to run as a command

If you have your SQL in a file on your system and just want to run it in the database, you do not want a prompt but to just have it run.

For example, to run the test.sql located in the OracleSqlcl subdirectory, navigate to that directory and run this command
```
docker run --rm --network=<network name> -v $(pwd):/source evilape/sqlcl:18.4.0 sys/<your password>@//OracleXE18c:1521/XE as sysdba @/source/test.sql
```
NOTE: You may need to change 18.4.0 to a different version if you have installed another version of SQLcl.

It runs the SQL and returns the answer. That is great but typing that every time one wants to run a piece of SQL or PL/SQL is a bit tedious. You are wlcome to do that, but I suggest using funtions for it.

#### Simplifying the use of SQLcl

Instead of writing that long command string every time it would be better to use an alias for it. Unfortunately an alias cannot use arguments so we need to define a function instead.

The simple version of it would be something like this:
```
sql() {
  docker run --rm --network=<network name> -v $(pwd):/source evilape/sqlcl:<version> sys/<your password>@//OracleXE18c:1521/XE as sysdba @/source/$*
}

Put it in a file and source it. Now you can say "sql test" to run the test.sql provided you've changed the things in <>. You could easily make it be for interactive use or have another function for it. However, it would be nicer to have a little bit more support.

There is a file called sql_alias.template in the OracleSqlcl subdirectory. We can use this to create a file for functions that do what you need.

To use the same password for all accounts you log in with (CDB and PDB) you run this command:

sed 's/\$\$\$\$\$\$\$\$//' sql_alias.template > sql_alias
sed 's/\$\$\$\$\$\$\$\$/EvilApe/' sql_alias.template > sql_alias
