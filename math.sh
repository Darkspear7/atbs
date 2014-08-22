#/bin/bash

function isInteger {
    if [ $# -eq 0 ]; then
        echo "Error: isNumeric missing parameter"
        exit 1
    fi
    
    if [[ $1 =~ ^[0-9]+$ ]]; then
        return 0
    fi
    return 1
}

function generateNumber {
    if [ $# -eq 0 ]; then
        echo "Error: generateNumber missing parameter"
        exit 1
    fi
    
    LENGTH=$1
    if ! isInteger $LENGTH; then
        echo "Error: generateNumber parameter must be integer"
        exit 1
    fi

    NUMBER=$(cat /dev/urandom | tr -dc '0-9' | fold -w $LENGTH | head -n 1) 
    NUMBER=$(echo $NUMBER | sed 's/^0*//')
    
    printf "%d" $NUMBER
    return 0
}

function getEquationByRating {
    if [ $# -eq 0 ]; then
        echo "Error: getEquationByRating missing parameter"
        exit 1
    fi
    
    RATING=$1
    if ! [[ $RATING =~ ^[0-9]+$ ]]; then
        echo "Error: getEquation parameter must be integer"
    fi
    
    MULTIPLICATION_DIGITS=1
    SUBTRACTION_DIGITS=3
    ADDITION_DIGITS=3
    OPERATIONS=( "+" "-" "*" )

    if [ $RATING -ge 50 ]; then
        OPERATIONS[2]="*"
        ADDITION_DIGITS=2
        SUBTRACTION_DIGITS=2
    fi
    
    if [ $RATING -ge 100 ]; then
        ADDITION_DIGITS=3
        SUBTRACTION_DIGITS=3
    fi

    if [ $RATING -ge 250 ]; then
        MULTIPLICATION_DIGITS=2
        ADDITION_DIGITS=3
        SUBTRACTION_DIGITS=3
    fi
   
    COUNT_OPERATIONS=${#OPERATIONS[@]}
    INDEX=$(($RANDOM % $COUNT_OPERATIONS))
    OPERATION="${OPERATIONS[ $INDEX ]}"

    FIRST_NUMBER=0
    SECOND_NUMBER=0
    case "$OPERATION" in
    "+")
        FIRST_DIGITS=$(( $ADDITION_DIGITS / 2 ))
        SECOND_DIGITS=$FIRST_DIGITS
        if [ $(($ADDITION_DIGITS % 2)) -eq 1 ]; then
            SECOND_DIGITS=$(($FIRST_DIGITS + 1))
        fi
        FIRST_NUMBER=$(generateNumber $FIRST_DIGITS)
        SECOND_NUMBER=$(generateNumber $SECOND_DIGITS)
        ;;
    "-")
        FIRST_NUMBER=$(generateNumber $SUBTRACTION_DIGITS)
        SECOND_NUMBER=$(generateNumber $SUBTRACTION_DIGITS)
        ;;
    "*")
        FIRST_NUMBER=$(generateNumber $MULTIPLICATION_DIGITS)
        SECOND_NUMBER=$(generateNumber $MULTIPLICATION_DIGITS)
        ;;
    esac

    echo "$FIRST_NUMBER $OPERATION $SECOND_NUMBER"
    return 0
}

RATING=0
QUIT=0

while [ $QUIT == 0 ]; do
    EQUATION=$(getEquationByRating $RATING)
    RESULT=$(($EQUATION))
    SECONDS=10
    echo "$EQUATION"
    printf "Answer: "
    if read -t $SECONDS USER_INPUT; then
        #echo "Input: $USER_INPUT"
        if [ "$USER_INPUT" == "q" ]; then
            QUIT=1
            break
        fi
        if ! [[ $USER_INPUT =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
            echo "Input invalid."
            continue
        fi
        
        if [ "$USER_INPUT" == "$RESULT" ]; then
            echo "You answered corecctly."
            RATING=$(($RATING + 10))
        else
            echo "You answered wrong."
            RATING=$(($RATING - 10))
            if [ $RATING -le 0 ]; then
                RATING=0
            fi
        fi
    else
        echo "Times up."    
    fi
done

