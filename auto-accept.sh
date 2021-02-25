#!/bin/bash

## Auto Accepter for SKALE delegations.
# Must be run with sk-val in $PATH
# Currently supports sk-val v1.1.1-2

## Usage:
# auto-accept.sh <VAL_ID>

if [[ ! $1 =~ ^[0-9]{1,2}$ ]]; then
  echo "Argument needs to be the numerical representation of your validator. Got '$1'"
  exit 255
fi

while true; do
  FNAME=/tmp/delegations_$1_$(date +%y%m%d%H%M)
  sk-val validator delegations $1 > $FNAME
  for i in $( cat $FNAME | grep PROPOSED | cut -d' ' -f1); do
    sk-val validator accept-delegation --delegation-id=$i --yes
  done

  ACCEPTED=$(grep PROPOSED $FNAME)
  if [[ $(echo $ACCEPTED -n | wc -l) -gt 0 ]]; then
    echo "Accepted the following: "
    echo $ACCEPTED
    echo ""
  fi
  sleep 120
done
