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

clear

tput setaf 5 #purple 

echo "==================================="
tput setaf 4 
echo " Welcome To Hangman Game"
tput setaf 3 
echo ""
echo "I will pick a secret word from the dictionary."
echo "You guess it one letter at a time."
echo "Each wrong guess adds a piece to the hangman figure!"
tput setaf 5 #purple
echo "==================================="


PLAY="Y"
# This loop continues until the user says
# they don't want to play again
while [[ "$PLAY" == "Y" || "$PLAY" == "y" || "$PLAY" == "YES" ||
     "$PLAY" == "Yes" || "$PLAY" == "yes" ]]
do
    # Ask for the word length (must be a number, 5 or more)
    LENGTH=0
    until [ "$LENGTH" -ge 5 ] 2>/dev/null
    do
        tput setaf 15   # White text
        read -p "Word length (minimum 5): " LENGTH
        if ! [ "$LENGTH" -ge 5 ] 2>/dev/null
        then
            tput setaf 1    # Red 
            echo "Please enter a number that is 5 or more."
        fi
    done

    # Ask for the maximum number of wrong guesses (1 or more)
    MAX=0
    until [ "$MAX" -ge 1 ] 2>/dev/null
    do
        tput setaf 15   # White 
        read -p "Maximum wrong guesses (minimum 1): " MAX
        if ! [ "$MAX" -ge 1 ] 2>/dev/null
        then
            tput setaf 1    # Red 
            echo "Please enter a number that is 1 or more."
        fi
    done


