#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

DOESNT_EXIST() {
  echo "I could not find that element in the database."
}

if [[ -z $1 ]]
then
  echo  "Please provide an element as an argument."
else
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    ELEMENT_BY_ATOMIC_NUMBER=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")

    if [[ ! -z $ELEMENT_BY_ATOMIC_NUMBER ]]
    then
      ELEMENT_INFO_COMPLETE=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $1")
      echo "$ELEMENT_INFO_COMPLETE" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE 
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    else
      DOESNT_EXIST
    fi
  else
    ELEMENT_BY_SYMBOL_OR_NAME=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' OR name = '$1'")

    if [[ ! -z $ELEMENT_BY_SYMBOL_OR_NAME ]]
    then
      ELEMENT_INFO_COMPLETE=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol = '$1' OR name = '$1'")
     echo "$ELEMENT_INFO_COMPLETE" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE 
      do
         echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    else
      DOESNT_EXIST
    fi  
  fi 
fi   
