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
    until [ "$MAX" -ge 20 ] 2>/dev/null
    do
        tput setaf 15   # White 
        read -p "Maximum wrong guesses (minimum 10): " MAX
        if ! [ "$MAX" -ge 1 ] 2>/dev/null
        then
            tput setaf 1    # Red 
            echo "Please enter a number that is 1 or more."
        fi
    done

 # Pick a random word of that length from the dictionary.
    # The grep pattern matches lowercase words of exactly LENGTH letters.
    WORD=$(grep "^[a-z]\{$LENGTH\}$" $DICT | shuf -n 1)

    # Make sure we actually found a word of that length
    if [ -z "$WORD" ]
    then
        tput setaf 1    # Red text
        echo "Error: no $LENGTH-letter words in the dictionary - try another length."
        continue
    fi

    # Un-comment this line when debugging!
    # echo "NOTE: the secret word is $WORD"

 # Draw the hangman figure - one body part per wrong guess
        clear
        tput setaf 6    # Cyan text
        echo "  +---+"
        echo "  |   |"
        if [ $WRONG -eq 0 ]
        then
            echo "      |"
            echo "      |"
            echo "      |"
        elif [ $WRONG -eq 1 ]
        then
            echo "  O   |"
            echo "      |"
            echo "      |"
        elif [ $WRONG -eq 2 ]
        then
            echo "  O   |"
            echo "  |   |"
            echo "      |"
        elif [ $WRONG -eq 3 ]
        then
            echo "  O   |"
            echo " /|   |"
            echo "      |"
   elif [ $WRONG -eq 4 ]
        then
            echo "  O   |"
            echo " /|\\  |"
            echo "      |"
        elif [ $WRONG -eq 5 ]
        then
            echo "  O   |"
            echo " /|\\  |"
            echo " /    |"
        else
            echo "  O   |"
            echo " /|\\  |"
            echo " / \\  |"
        fi
        echo "      |"
        echo "========="
        echo

        tput setaf 15   
        echo "Word:    $SHOW"
        echo "Guessed: $GUESSED"
        echo "Wrong:   $WRONG / $MAX"
        echo

        # Did the user win?
        if [ "$FOUND" == "Y" ]
        then
            # Each unused guess is worth 10 points
            SCORE=$(( (MAX - WRONG) * 10 ))
            ((WINS++))
            tput setaf 10   # Green 
            echo "You WIN! The word was $WORD."
            echo "Score this game: $SCORE points"
            break
        fi

        # Did the user lose? (too many wrong guesses)
        if [ $WRONG -ge $MAX ]
        then
            tput setaf 11   # Yellow 
            echo "You LOSE! The word was $WORD."
            break
        fi


      
        # Read the next guess
        tput setaf 15   # White text
        read -p "Guess a letter: " GUESS

        # Change uppercase to lowercase so 'A' works like 'a'
        GUESS=$(echo $GUESS | tr A-Z a-z)

        # The guess must be exactly one letter from a to z
        if [[ "$GUESS" != [a-z] ]]
        then
            tput setaf 1    # Red text
            echo "Please enter one letter (a-z)."
            sleep 1
            continue
        fi

        # Reject a letter that was already guessed
        if echo "$GUESSED" | grep -q "$GUESS"
        then
            tput setaf 1    # Red text
            echo "You already tried '$GUESS'."
            sleep 1
            continue
        fi

       # Remember this guess
        GUESSED="$GUESSED$GUESS"

         # If the letter is not in the word, it is a wrong guess
        if ! echo "$WORD" | grep -q "$GUESS"
          then
            ((WRONG++))
          fi
             done
      tput setaf 15   # White text
    echo
    read -p "Do you want to play again (Y/N)? " PLAY
    echo
done

tput setaf 5    # Purple 
echo "You played $GAMES games and won $WINS times ($((WINS*100/GAMES))% success)."

echo
tput sgr0  
