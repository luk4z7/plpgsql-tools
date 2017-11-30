#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
RED='\033[0;31m'
LIGHT_RED='\033[1;31m'
GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
LIGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m'

clear

# Head
echo ' '
printf "${GREEN}https://github.com/luk4z7/plpgsql-tools for the canonical source repository \n"
printf "Helpers for PL/pgSQL applications\n"
echo ' '

if [ $(uname) == "Darwin" ]; then
    ENVIRONMENT='MAC'
else
    ENVIRONMENT='LINUX'
fi
echo ' '

if [ $ENVIRONMENT == 'LINUX' ]; then
    if which figlet > /dev/null; then
        printf "${GREEN}"
        figlet PL/pgSQL
    else
        if which apt-get > /dev/null; then
            apt-get install -y figlet > /dev/null;
        fi
        if which yum > /dev/null; then
            yum install -y figlet > /dev/null;
        fi
        if which figlet > /dev/null; then
            printf "${GREEN}"
            figlet PL/pgSQL
        fi
    fi
    echo ' '
    printf "${NC}"
fi

# check the installation for postgresql
if which pg_dump > /dev/null; then
	printf "${ORANGE}PostgreSQL${NC}\n"
    printf "${LIGHT_PURPLE}Enter the database name:${NC}\n"
    read database

	if [ -n "$database" ]; then

        printf "${LIGHT_PURPLE}Enter the username:${NC}\n"
        read username
        if [ -n "$username" ]; then

            printf "${LIGHT_PURPLE}Enter the password:${NC}\n"
            read password
            if [ -n "$password" ]; then

                printf "${ORANGE}Deploy functions ... ${NC}\n"
		        $(which psql) -U $username --password $password -d $database -f structure.sql
            fi
        fi
	fi
	echo ' '
else
    printf "${BLUE}Installation of PostgreSQL not found${NC}\n"
fi