#!/usr/bin/sh
if [ ! -d "$2" ]; then
  echo 'Parameter 2 needs to be an existing directory.'
  exit
fi

if (( ! $(ls -A $2| wc -l) == 0)); then
  echo 'Parameter 2 needs to be an empty directory. It is where you want datafiles and ORDS-config to be stored.'
  exit
fi

if (( ${#3} < 4)); then
  echo 'Parameter 3 needs to be a password of at least 4 characters.'
  echo 'No, not very secure, but this is for a personal development environment. You are free to be more secure.'
  exit
fi

docker network create --driver bridge oracle_isolated_network
