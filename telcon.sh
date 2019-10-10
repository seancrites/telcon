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

DNS_LOOKUP=$(host -t SRV _con._tcp.${HOST_CLI})

if [ "$?" -ne 0 ]; then
   # SRV lookup failed, now trying a simple con.HOST lookup.
   printf " --- SRV Lookup failed; trying con.${HOST_CLI}\n"
   DNS_LOOKUP=$(host con.${HOST_CLI})
   if [ "$?" -ne 0 ]; then
      # con.HOST failed, exiting.
      printf " --- con.${HOST_CLI} failed, exiting.\n"
      exit 1;
   else
      # con.[host_name] success, setting standard telnet port and concantenated hostname.
      printf " --- Found con.${HOST_CLI}, using standard telnet port 23.\n"
      CONSOLE_PORT="23"
      CONSOLE_SERVER="con.${HOST_CLI}"
   fi
else
   # SRV lookup succeeded, parsing lookup reply, setting port & server.
   CONSOLE_PORT="$(echo ${DNS_LOOKUP} | cut -d\  -f7)"
   CONSOLE_SERVER="$(echo ${DNS_LOOKUP} | cut -d\  -f8 | rev | cut -c 2- | rev)"
   printf " --- SRV lookup succeeded. Using ${CONSOLE_SERVER} and port ${CONSOLE_PORT}.\n"
fi

# Connect to terminal server
telnet ${CONSOLE_SERVER} ${CONSOLE_PORT}

if [ "$?" -ne 0 ]; then
    exit 1;
fi


















