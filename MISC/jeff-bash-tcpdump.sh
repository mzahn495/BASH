#!/usr/local/bin/bash

for c in `cat /usr/local/etc/customer.conf | grep -v ^# | pcregrep -v '^\s+?$' | awk '{print $2}' | sort -u`; do 
     IPRANGE=`cat /usr/local/etc/customer.conf | pcregrep "\s+$c\s?$" | awk '{print $1}' | pcregrep '^[0-9\.\/]+$'`
	 
	 NUM='#'
	 TCPDUMP='tcpdump -ni igb0'
	 QUERY='\('
	 
	 for i in $IPRANGE; do
	     QUERY="${QUERY} net $i or"
	 done
	 
	 QUERY=`echo $echo $QUERY | sed -e 's/ or$//'`
	 QUERY+=') and \(host 204.131.205.129 or host 204.131.205.130 or host 204.131.250.131 or host 204.131.205.132\)'
	 
	 echo -e "$NUM "$c
	 echo "$TCPDUMP $QUERY"
done