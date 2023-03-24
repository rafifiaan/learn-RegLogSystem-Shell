#!/bin/bash

#Register System User

#Deliver message to log.txt
function log_message {
   echo $(date +"%y/%m/%d %T") $1 >> log.txt
}

#Register a new user
function register_user {
   #read user & pw from user input
   read -p "Masukkan Username : " username
   read -p "Masukkan Password : " password

   #Password Requirements
   if ! [[ $password =~ ^[A-Za-z0-9]+_[A-Za-z0-9]+.*$ && ${#password} -ge 8 && "$password" != *chicken* && "$password" != *ernie* && "$password" != "$username" && "$password" == *[A-Z]* && "$password" == *[a-z]* && "$password" == *[0-9]* ]];
      then
        echo "Password does not match!"
        exit 1
   fi

   #Check username
   if grep -q "^$username: " /users/users.txt;
      then
      log_message "REGISTER : ERROR User already exist"
      echo "ERROR : User already exist."
      echo "-----------Oops!-----------"
   else
      #Add user to users.txt
      echo "$username : $password" >> /users/users.txt
      log_message "REGISTER : INFO User $username registered successfully"
      echo "Success : User $username registered successfully"
      echo "-------------------Welcome!---------------------"
      exit 1
   fi
}

#Interface
while true;
do
  echo "Let's Register!"
	  register_user
done
