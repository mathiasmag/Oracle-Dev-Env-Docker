# Build and run the images
Now that the pre-requisites has been completed, we just need to build the images and then start the containers.

## Move downloaded files to where we need them
The utility to build this expects the downloaded files to be placed in .../devenv/evilape/Oracle-Dev-Env-Docker-master/dockerimages. This plce was created when we ran the commands to download the docker-projects.

```
cp ~/devenv_src/* ~/devenv/evilape/Oracle-Dev-Env-Docker-master/dockerimages
```
That assumes you have created both devenv nd devenv_src in your homedirectory, if not adjust as needed.

## Execute the script to build the images

In the same directory where you put the zip-files, there is a script buildall.sh. It builds all images needed for the dev elopment environment.

for example:
- $ ./buildall.sh

NOTE: It writes all standard output to buildall.log. It only shows each steps it starts as output to the user. Tail that file if you want to follow how the process goes.

Warnings and errors written to standard error shown up. There should be none. With the known exception of these that may show up twice.

```
WARNING: bridge-nf-call-iptables is disabled
WARNING: bridge-nf-call-ip6tables is disabled
```
## Execute the script to create and start the containers

Create a directory to hold docker volumes, that is file sthat are stored outside of the containers. Specifically, here it is used for database files and for the ORDS-config. It has to be writeable by user 54321 that is the oracle user in the containers. 
For example.
- $ mkdir ~/dkr_volumes

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
´´´
docker run --rm --network=<network name> -it evilape/sqlcl:18.4.0 sys/<your password>@//OracleXE18c:1521/XE as sysdba
´´´
NOTE: You may need to change 18.4.0 to a different version if you have installed another version of SQLcl.

You get logged in and can do your work. When you exit the container is removed so you can just run again. Just like normal.

To simplify this, read on.

#### SQLcl to run as a command

If you have your SQL in a file on your system and just want to run it in the database, you do not want a prompt but to just have it run.

For example, to run the test.sql located in the OracleSqlcl subdirectory, navigate to that directory and run this command
```
docker run --rm --network=<network name> -v $(pwd):/source evilape/sqlcl:18.4.0 \
       sys/<your password>@//OracleXE18c:1521/XE as sysdba @/source/test.sql
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
```

Put it in a file and source it. Now you can say "sql test" to run the test.sql provided you've changed the things in <>. You could easily make it be for interactive use or have another function for it. However, it would be nicer to have a little bit more support.

There is a file called sql_alias.template in the OracleSqlcl subdirectory. We can use this to create a file for functions that do what you need.

To use the same password for all accounts you log in with (CDB and PDB) you run this command:
```
sed 's/\$\$\$\$\$\$\$\$/<your password>/' sql_alias.template > sql_alias
```

To be prompted for all accounts you log in with (CDB and PDB) you run this command:
```
sed 's/\$\$\$\$\$\$\$\$//' sql_alias.template > sql_alias
```

Now all you need to do is to source the sql_alias file.

With this you can test four different commands to see it work in interactive mode:
```
sql
sql_xe_sys
sql_xe_system
sql_xepdb1_pdbadmin
```
If you set up the file with a password you get logged in to a SQL prompt, if not, you will first be prompted for the password by SQLcl.

You can also use them to have it run a file. there is a "test.sql" in the same directory so to run it with one of those users issue, issue one or all of these:
```
sql test
sql_xe_sys test
sql_xe_system test
sql_xepdb1_pdbadmin test
```
The command "sql" and "sql_xe_sys" does the same exact thing. The latter is more declarative in what it does.

The structure here is sql is just the reference to the base function. the second node "xe/xepdb1" references the "database". It is the service defined. Either CDB or PDB. The last one "sys/system/pdbadmin" is the user to log in as.

The only function with any logic is "sql". The rest are just names that calls the "sql" function which checks which of these the user called and uses the parts as explained.

If you create a new user in the PDB like so:
```
$ sql_xe_system
alter session set container=xepdb1;
create user testuser identified by EvilApe;
grant create session to testuser;
exit
```
Here the password "EvilApe" is what is used by all users if we're logging in without being prompted for a password.

Now you can set up your own "alias" for it. Create a file for it. F.e. sql_alias_custom
place one line in it conataining this:
```
sql_xepdb1_testuser() { sql $*; }
```
Now you can log in by just issuing "sql_xepdb1_testuser".

With this setup there need to maintain TNS-aliases or have oracle drivers. You can of course, if you prefer, modify the "sql" function to accept parameters.

Do move sql_alias and sql_alias_custom (or what you named that file) to your own directory so it is not lost if you remove and reinstall this development environment in the future.

#### SQL Developer

There really is nothing special with setting up connections in SQL developer to access the database.
- Give the connection a name like local_xe_sys
- Username sys
- Password what you choosed - EvilApe in the examples
- Connection Type Basic
- Role SYSDBA for SYS, typically default for other users
- Hostname localhost
- Port 1521 or if you chosed to map a different port from your system to the container
- Service Name XE. XE for the CDB (SYS/SYSTEM) and XEPDB1 for the PDB (PDBADMIN)

NOTE: Use service name for both CDB and PDB, it makes life easier to not refer directly to SID anymore.

That is it, you can now conect.

#### APEX Development environment

You have a full Oracle Rest Data Service configured, The APEX environment us unlocked and ready to go.

For administering the environment, including creating workspace and developer user start with
- http://localhost:8888/ords/apex_admin

Then to log on to the development environment head over to:
- http://localhost:8888/ords/apex_admin

You log in to the admin with user ADMIN and the password you selected to use for all users (EvilApe in the examples)

In the developoment environment you log into the workspace you created with the user you created.

#### Oracle Enterprise Manager Express

OEM Express is configured on this address:
- https://localhost:5500/em/

This is however currently failing on a certificate issue. Probably due to the linux used as based for the ORDS-install. 

## You are good to go

Assuming everyhing above worked for you, you are now able to work with your local database development environment and extend as you wish. Create new pluggable databases, set up more things in ORDS, play with REST and so forth. Modifying REST configuration is done in the ORDS-volume where the configuration files are located. To get REST fully functional you may need to unlock some users, I leave testing that to the reader.

## Leave Feedback

Please drop me a note if you find this useful or if something was confusing or flat out wrong.