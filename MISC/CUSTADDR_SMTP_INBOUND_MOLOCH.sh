#!/bin/bash


# port.dst == 25 && ip.dst == 65.127.216.64/27 && email.src ==  " *@fbi.gov" || email.src == "*@leo.gov" || email.src == "*@infragard.org" || email.src == "*@listserv.leo.gov" || email.src == "*@tsc.gov"
# Commos  | sed -e 's/ /, /g' 
function CUSTADDR_SMTP_INBOUND_MOLOCH() {
    for c in `cat /export/home/mzahn/customer | grep -v ^# | pcregrep -v '^\s+?$' |  awk '{print $2}' | sort -u`; do
       DOMAINS=` cat /export/home/mzahn/customer | pcregrep "\s+$c\s?$" | awk '{print $1}' | pcregrep '[a-z\.\/]+$'`

       VAR1='port.dst == 25 && ip.dst == 65.127.216.64/27 &&' 
       VAR2='email.src == \"*@'
       
       
       VAR7="## Inbound SMTP Traffic"
       QUERY=' '
       # We are going to have to loop through the domain names 
        
        for x in $DOMAINS; do
            QUERY="${QUERY}email.src == \"*@$x\" || "
            
        done
            
        QUERY=`echo $QUERY | sed -e 's/ ||$//'`
        
       printf "$VAR7 $c\n\n"
       printf "$VAR1 $QUERY"
       printf "\n\n"
 
        
    done 
    
}

CUSTADDR_SMTP_INBOUND_MOLOCH 




