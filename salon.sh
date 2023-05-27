#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nHi! How may I help you today? Here it's a list of services we provide:" 
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME Service"
  done
  echo "0) Exit"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SERVICE_MENU ;;
    2) SERVICE_MENU ;;
    3) SERVICE_MENU ;;
    0) EXIT ;;
    *) MAIN_MENU "Please select a valid option." ;;
  esac
}

SERVICE_MENU() {
  echo -e "\nPlease insert your phone number:"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
   if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  echo -e "\nHi, $CUSTOMER_NAME! Please choose a time for your appointment:"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME',  $SERVICE_ID_SELECTED, $CUSTOMER_ID)")
  
  SERVICE_NAME=$($PSQL "SELECT name FROM SERVICES WHERE service_id = $SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

EXIT() {
  echo "EXIT"
}

MAIN_MENU