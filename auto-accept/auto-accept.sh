#!/bin/bash

## Auto Accepter for SKALE delegations.

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

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
