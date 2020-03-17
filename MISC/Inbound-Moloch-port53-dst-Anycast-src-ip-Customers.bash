#!/bin/bash
for c in `cat /export/home/mzahn/customer | grep -v ^# | pcregrep -v '^\s+?$' |  awk '{print $2}' | sort -u`; do
   IPRANGE=`cat /export/home/mzahn/customer | pcregrep "\s+$c\s?$" | awk '{print $1}' | pcregrep '^[0-9\.\/]+$'`

   
   VAR1="port.dst == 53 && ip.dst == [204.131.205.129, 204.131.205.130, 204.131.205.129, 204.131.205.131] && ip.src == ["
   VAR2=']'
   VAR3=`echo ${IPRANGE} | sed -e 's/ /, /g'`
   VAR4='    '
   VAR5="## Inbound DNS Traffic"
   # might have to add variable c to the QUERY for Trouble Shooting 
   #QUERY=`echo -e $c ${VAR4} $VAR1 $VAR3 $VAR2`
   #echo "$c ${VAR4} $VAR1 $VAR3 $VAR2"
   printf "$VAR5 $c\n\n"
   printf "$VAR1 $VAR3 $VAR2 "
   printf "\n\n" 
   #echo $QUERY
done
