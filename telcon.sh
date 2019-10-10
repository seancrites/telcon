#!/bin/sh
set -o nounset

# Telnet wrapper for Cisco terminal server

[ $# -eq 0 ] && 
   {
      printf "\n";
      printf "   Purpose: Use DNS SRV records to determine Terminal Server\n";
      printf "            and initiate a telnet session to that port\n\n";
      printf "   Usage: $0 HOST\n\n";
      exit 0; 
   }

HOST_CLI="$1"

#DNS_LOOKUP=$(host -s -W 1 -t SRV _con._tcp.$HOST_CLI)
DNS_LOOKUP=$(host -t SRV _con._tcp.${HOST_CLI})

if [ "$?" -ne 0 ]; then
   printf "\n"
   printf " --- Unable to find SRV console entry in DNS\n"
   printf " --- Trying con.${HOST_CLI}\n"
   
   DNS_LOOKUP=$(host con.${HOST_CLI})

   if [ "$?" -ne 0 ]; then
      printf " --- Unable to resolve con.${HOST_CLI}.\n"
      printf " --- Thanks for playing."
      exit 1;
   else
      printf " --- Success!\n"
      CONSOLE_PORT="23"
      CONSOLE_SERVER="con.${HOST_CLI}"
   fi

else
   CONSOLE_PORT="$(echo ${DNS_LOOKUP} | cut -d\  -f7)"
   CONSOLE_SERVER="$(echo ${DNS_LOOKUP} | cut -d\  -f8 | rev | cut -c 2- | rev)"
fi
printf "\n"
printf " --- Console Port: ${CONSOLE_PORT}\n"
printf " --- Console Port: ${CONSOLE_SERVER}\n"

printf "\n"

# Connect to terminal server
telnet ${CONSOLE_SERVER} ${CONSOLE_PORT}



















