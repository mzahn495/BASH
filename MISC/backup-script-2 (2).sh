#!/bin/bash

who -a  | grep -v root | grep "+" | awk '{print $7}' | xargs -n1 kill -9

tar czf /home.czf /home

#!/bin/bash

# crontab below
# 59 1 * * 1-5 /root/backups.sh

who -a  | grep -v root | grep "+" | awk '{print $7}' | xargs -n1 kill -9

tar czf /home.czf /home

# tar czf /home.`date +%m%d%y:%H%M`.czf /home
# find /home -type f -ctime +90 | xargs -n1 rm -f

##############################################



#!/bin/bash

# clear rhe screen
clear

# start a while loop
while true
do
  # print a menu
  echo "Enter 1 to backup the /home folder."
  echo "Enter 2 to add a user to the system".

  # read the users answer to the menu
  read answer

  # if the answer is 1 then backup using tar
  if [ $answer -eq 1 ];
    then
     # backup up /home folder,call it /home.MonthDayYear:HourMinute
     tar czf /home.`date +%m%d%y:%H%M`.czf /home
    elif
     # if the answer is 2 then add a user
     [ $answer -eq 2 ];
    then
     # Ask what the user name should be
     echo "What user do you want to add?"
     # read in the input and assign it to a variable
     read username
     # Add the user we just entered in
     adduser $username
  fi

  echo "Press CTRL-C then <enter> to exit, or any other key to continue."
  read asdjfhasdhf
  clear

done
