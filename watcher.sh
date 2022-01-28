#! /bin/bash

# Load our config file
if [ -f .env.local ]
then
  export $(cat .env.local | sed 's/#.*//g' | xargs)
fi

API_ENDPOINT="https://xchain.io/api"
API_DISPENSER="$API_ENDPOINT/dispensers"
IFS=$'\n' read -d '' -r -a ASSETS < ./assets.txt
DATA_FILE="./data.csv"
SLEEP_TIME="1" # Do NOT set to 0! This is to prevent DoSing Counterparty servers

notification() {
  SUBJECT="New Dispenser"
  MESSAGE="New dispenser for $ASSET is available."

  if [[ "$NOTIFICATION" = "pushover" ]]; then
    echo "Sending a notification through Pushover."

    if [[ -n "$PUSHOVER_USER" && -n "$PUSHOVER_TOKEN" ]]; then
      curl -w "\n" -s \
      --form-string "token=$PUSHOVER_TOKEN" \
      --form-string "user=$PUSHOVER_USER" \
      --form-string "message=$MESSAGE" \
      --form-string "title=$SUBJECT" \
      --form-string "html=1" \
      https://api.pushover.net/1/messages.json
    else
      echo "PUSHOVER_USER and/or PUSHOVER_TOKEN not configured."
    fi
  elif [[ "$NOTIFICATION" = "email" ]]; then
    if [[ -n "$EMAIL_ADDRESS" ]]; then
      echo "Sending email to $EMAIL_ADDRESS."
      echo $MESSAGE | mail -s $SUBJECT $EMAIL_ADDRESS
    else
      echo "EMAIL_ADDRESS not configured."
    fi
  fi
}

for ASSET in "${ASSETS[@]}"
do
  echo "Retrieving data for $ASSET..."
  JSON="`wget -qO- $API_DISPENSER/$ASSET`"

  # Adding a bit of sleep to prevent DoSing counterparty servers
  sleep $SLEEP_TIME

  LAST_BLOCK=$(echo $JSON | jq '.data[0] | .block_index')

  # Read existing data about assets
  touch -a $DATA_FILE
  IFS="," read -ra A <<< "$(grep $ASSET $DATA_FILE | tr '\n' '\0')"
  CSV_ASSET=${A[0]}
  CSV_BLOCK=${A[1]}

  # There's currently no data so we saved the fetched one
  if [ -z "$CSV_ASSET" ]; then
    echo "Saving $ASSET data."
    echo "$ASSET,$LAST_BLOCK" >> $DATA_FILE
    notification
  else
    # Update with new data
    if [ $LAST_BLOCK -gt $CSV_BLOCK ]; then
      echo "Updating $ASSET on block $LAST_BLOCK."
      awk 'BEGIN{FS=OFS=","} $1=="'$ASSET'"{$2="'$LAST_BLOCK'"} 1' $DATA_FILE > tmp && mv tmp $DATA_FILE
      notification
    else 
      echo "No new changes available."
    fi
  fi
done