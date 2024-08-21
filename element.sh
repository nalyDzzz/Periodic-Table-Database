#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  INPUT=$1
  if [[ $INPUT =~ ^[0-9]+$ ]]
    then
      ID_QUERY_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$1'")
    else
      ID_QUERY_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1' OR symbol = '$1'")
  fi
  if [[ -z $ID_QUERY_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = '$ID_QUERY_RESULT'")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$ID_QUERY_RESULT'")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM types JOIN properties USING (type_id) WHERE atomic_number = '$ID_QUERY_RESULT'")
    ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$ID_QUERY_RESULT'")
    ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$ID_QUERY_RESULT'")
    ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$ID_QUERY_RESULT'")
    echo "The element with atomic number $ID_QUERY_RESULT is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
  fi
fi