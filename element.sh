#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

GET_INFO() {
  # If user enters a argument
  if [[ $1 ]]
  then
    # If argument is a number
    if [[ $1 =~ ^[0-9]*$ ]]
    then  
      # get atomic number
      GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
      # Check if number is in our database
      if [[ -z $GET_ATOMIC_NUMBER ]]
      # If its not...
      then
        echo "I could not find that element in the database."
      # If we find the number
      else
      # Call function to print
      PRINT_INFO $GET_ATOMIC_NUMBER
      fi  

    else 
      # Check if argument is 1 or 2 letters (symbol)
      if [[ ${#1} -eq 2 || ${#1} -eq 1 ]]     
      then         
        # Get atomic number
        GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
        # Check if number is in our database
        if [[ -z $GET_ATOMIC_NUMBER ]]
        # If its not..
        then
          echo "I could not find that element in the database."
        # If we find the number
        else
        # Call function to print
        PRINT_INFO $GET_ATOMIC_NUMBER
        fi
      else
        # Get atomic number
        GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
        # Check if number is in our database
        if [[ -z $GET_ATOMIC_NUMBER ]]
        # If its not..
        then
          echo "I could not find that element in the database."
        # If we find the number
        else
        # Call function to print
          PRINT_INFO $GET_ATOMIC_NUMBER
        fi
      fi    
    fi
  else
    # Error message if no arguments given
    echo -e "Please provide an element as an argument."
  fi  
}

PRINT_INFO(){
  # Get all needed information
  GET_ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE elements.atomic_number = '$1'")
  # While loop to print out message
  echo $GET_ELEMENT_INFO | while IFS=" |" read ATOMIC_NUM NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT 
do
  echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
}

GET_INFO $1