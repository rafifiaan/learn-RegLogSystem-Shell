#!/bin/bash

#Login System User

#Deliver message to log.txt
function log_message {
   echo $(date +"%y/%m/%d %T") $1 >> log.txt
}

#Login user
function login_user {
    #read user & pw  from user input
    read -p "Masukkan Username : " username
    read -p "Masukkan Password : " password

    #check if username exist in users.txt and password is correct
   if grep -q "^$username : $password" /users/users.txt
      then
      log_message "LOGIN : INFO User $username logged in"
      echo "Success : User $username logged in"
      echo "---------Congratulations!---------"
	exit 1
   else
      log_message "LOGIN : ERROR Failed login attempt on user $username"
      echo "Error : Failed login attempt on user $username "
      echo "------------------Try again-------------------" 
   fi
}

#Interface
while true;
do
  echo "Let's Login!"
	login_user
done


