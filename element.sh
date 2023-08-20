#!/bin/bash 

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

PRINT() {
  if [[ -z $1 ]]
  then
    echo "I could not find that element in the database."
  else
    echo $1 | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
fi
}


# if input is empty
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 = [0-9]* ]]
then
  #search for number
  ELEMENT_SEARCHED=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  PRINT $ELEMENT_SEARCHED
else
  #search for string
  ELEMENT_SEARCHED=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING(type_id) WHERE name='$1' OR symbol='$1'")
  PRINT $ELEMENT_SEARCHED
fi
