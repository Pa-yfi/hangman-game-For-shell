#!/usr/bin/bash

#credential variables

Game=0
Wins=0


#I'm gonna assign some colour arrangments

red=$(tput setaf 1)
green=$(tput setaf 2)
purple=$(tput setaf 5)
white=$(tput sgr0)


#First we assign a directed wordlist


#Dict=/usr/share/dict/words


#check if it is validated

if [ ! -f "$Dict" ]
then

echo "file isn't found"
 fi
