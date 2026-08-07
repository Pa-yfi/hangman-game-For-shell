#!/usr/bin/bash

# hangman.sh - Hangman game (OPS102 bonus lab)
#
# The user picks the word length and the maximum number of
# wrong guesses, then guesses the secret word one letter
# at a time.  See:  https://en.wikipedia.org/wiki/Hangman_(game)

# ---------- Variables we use for the whole session ----------

GAMES=0     # How many games have been played
WINS=0      # How many games the user has won
BLANK="_ "  # One hidden letter.  We keep this in a variable because
            # writing "$SHOW_ " would look like a variable named SHOW_

# The wordlist - change this path if your file lives somewhere else
DICT="/usr/share/dict/words"

# Make sure the wordlist exists before we start
if [ ! -f "$DICT" ]
then
    echo "Error: wordlist '$DICT' not found." >&2
    exit 1
fi

# ---------- Welcome message ----------

clear

tput setaf 5    # Purple
echo "==================================="
tput setaf 4    # Blue
echo " Welcome To Hangman Game"
tput setaf 3    # Yellow
echo ""
echo "I will pick a secret word from the dictionary."
echo "You guess it one letter at a time."
echo "Each wrong guess adds a piece to the hangman figure!"
tput setaf 5    # Purple
echo "==================================="

# ---------- Outer loop: one pass = one game ----------

PLAY="y"
while [ "$PLAY" = "y" ]
do
    # ----- Ask for the word length (a number, 5 or more) -----
    # OK stays "N" until the user types something we can use
    OK="N"
    while [ "$OK" = "N" ]
    do
        tput setaf 15   # White
        read -p "Word length (minimum 5): " LENGTH

        # grep checks the answer is only digits.
        # An "if" can test any command, not just [ ] - here it
        # tests whether grep found a match.  The ! means "not".
        if ! echo "$LENGTH" | grep -q "^[0-9][0-9]*$"
        then
            tput setaf 1    # Red
            echo "Please type a number."
        elif [ "$LENGTH" -lt 5 ]
        then
            tput setaf 1    # Red
            echo "The minimum length is 5."
        else
            OK="Y"
        fi
    done

    # ----- Ask for the maximum number of wrong guesses -----
    OK="N"
    while [ "$OK" = "N" ]
    do
        tput setaf 15   # White
        read -p "Maximum wrong guesses (minimum 6): " MAX

        if ! echo "$MAX" | grep -q "^[0-9][0-9]*$"
        then
            tput setaf 1    # Red
            echo "Please type a number."
        elif [ "$MAX" -lt 6 ]
        then
            tput setaf 1    # Red
            echo "The minimum is 6."
        else
            OK="Y"
        fi
    done

    # ----- Pick a random word of that length -----
    # The grep pattern matches lowercase words of exactly LENGTH letters
    WORD=$(grep "^[a-z]\{$LENGTH\}$" "$DICT" | shuf -n 1)

    # Make sure we actually found a word of that length
    if [ -z "$WORD" ]
    then
        tput setaf 1    # Red
        echo "Sorry, there are no $LENGTH-letter words in the dictionary."
        echo "Please try a different length."
        sleep 2
    else
        # Un-comment this line when debugging!
        # echo "NOTE: the secret word is $WORD"

        # ----- Start a fresh game -----
        WRONG=0         # Wrong guesses so far
        GUESSED=""      # All the letters tried so far
        GAMES=$((GAMES + 1))
        PLAYING="Y"     # Stays "Y" until this game ends

        # ----- Inner loop: one pass = one guess -----
        while [ "$PLAYING" = "Y" ]
        do
            # Build the word to show on screen, one letter at a time.
            # FOUND stays "Y" only if every letter has been guessed.
            SHOW=""
            FOUND="Y"

            # seq 1 5 prints the numbers 1 2 3 4 5, so I counts
            # through the letter positions of the word
            for I in $(seq 1 $LENGTH)
            do
                # cut -c$I takes just letter number I out of the word
                LETTER=$(echo "$WORD" | cut -c$I)

                if echo "$GUESSED" | grep -q "$LETTER"
                then
                    SHOW="$SHOW$LETTER "
                else
                    SHOW="$SHOW$BLANK"
                    FOUND="N"
                fi
            done

            # ----- Draw the hangman: one body part per wrong guess -----
            clear
            tput setaf 6    # Cyan
            echo "  +---+"
            echo "  |   |"
            if [ "$WRONG" -eq 0 ]
            then
                echo "      |"
                echo "      |"
                echo "      |"
            elif [ "$WRONG" -eq 1 ]
            then
                echo "  O   |"
                echo "      |"
                echo "      |"
            elif [ "$WRONG" -eq 2 ]
            then
                echo "  O   |"
                echo "  |   |"
                echo "      |"
            elif [ "$WRONG" -eq 3 ]
            then
                echo "  O   |"
                echo " /|   |"
                echo "      |"
            elif [ "$WRONG" -eq 4 ]
            then
                echo "  O   |"
                echo " /|\\  |"
                echo "      |"
            elif [ "$WRONG" -eq 5 ]
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

            # ----- Show the score board -----
            tput setaf 15   # White
            echo "Word:    $SHOW"
            echo "Guessed: $GUESSED"
            echo "Wrong:   $WRONG / $MAX"
            echo

            # ----- Win, lose, or ask for another guess -----
            if [ "$FOUND" = "Y" ]
            then
                # Every guess the user did not need is worth 10 points
                SCORE=$(((MAX - WRONG) * 10))
                WINS=$((WINS + 1))
                PLAYING="N"
                tput setaf 10   # Green
                echo "You WIN!  The word was $WORD."
                echo "Score this game: $SCORE points"

            elif [ "$WRONG" -ge "$MAX" ]
            then
                PLAYING="N"
                tput setaf 11   # Yellow
                echo "You LOSE!  The word was $WORD."

            else
                tput setaf 15   # White
                read -p "Guess a letter: " GUESS

                # tr changes uppercase to lowercase, so A works like a
                GUESS=$(echo "$GUESS" | tr A-Z a-z)

                if ! echo "$GUESS" | grep -q "^[a-z]$"
                then
                    tput setaf 1    # Red
                    echo "Please type one letter from a to z."
                    sleep 1
                elif echo "$GUESSED" | grep -q "$GUESS"
                then
                    tput setaf 1    # Red
                    echo "You already tried $GUESS."
                    sleep 1
                else
                    # Add the new letter to the list of guesses
                    GUESSED="$GUESSED$GUESS"

                    # If the letter is not in the word, it was wrong
                    if ! echo "$WORD" | grep -q "$GUESS"
                    then
                        WRONG=$((WRONG + 1))
                    fi
                fi
            fi
        done

        # ----- Ask about another game -----
        tput setaf 15   # White
        echo
        read -p "Do you want to play again (Y/N)? " PLAY
        PLAY=$(echo "$PLAY" | tr A-Z a-z)
        echo
    fi
done

# ---------- Final report ----------

tput setaf 5    # Purple
if [ "$GAMES" -gt 0 ]
then
    # The multiplication must come before the division
    # because this is integer math
    echo "You played $GAMES games and won $WINS times ($((WINS * 100 / GAMES))% success)."
else
    echo "You did not finish any games."
fi

echo
tput sgr0   # Back to normal text
