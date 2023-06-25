#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

NOT_FOUND(){
      echo "I could not find that element in the database."
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  #if element is an integer
  if [[  $1 =~ ^[0-9]+$ ]]
  then
    # retornar info filtrando pelo atomic_number
    ATOMIC_NUMBER_RESULT=$($PSQL "select elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type_id, type from elements inner join properties on elements.atomic_number = properties.atomic_number inner join types on types.type_id = properties.type_id where elements.atomic_number = $1")

    # if not return the atomic number input
    if [[ -z $ATOMIC_NUMBER_RESULT ]]
    then 
      NOT_FOUND
    else
      echo $ATOMIC_NUMBER_RESULT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  else
  # if element is not an integer (is a string) 
    # if element lenght is less than 3
      if [[  ${#1} -lt 3  ]]
      then
        ATOMIC_NUMBER_RESULT=$($PSQL "select elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type_id, type from elements inner join properties on elements.atomic_number = properties.atomic_number inner join types on types.type_id = properties.type_id where elements.symbol = '$1'")
        # if not return the symbol input
        if [[ -z $ATOMIC_NUMBER_RESULT ]]
        then 
          NOT_FOUND
        else
          echo $ATOMIC_NUMBER_RESULT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID TYPE
          do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
          done
        fi
      else
     # if element lenght is equal or bigger than 3
        ATOMIC_NUMBER_RESULT=$($PSQL "select elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type_id, type from elements inner join properties on elements.atomic_number = properties.atomic_number inner join types on types.type_id = properties.type_id where elements.name = '$1'")
        # if not return the name input
        if [[ -z $ATOMIC_NUMBER_RESULT ]]
        then 
          NOT_FOUND
        else
          echo $ATOMIC_NUMBER_RESULT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID TYPE
          do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
          done
        fi
      fi
  fi
fi
