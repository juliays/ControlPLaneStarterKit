#!/bin/bash

function createContainerIfNotExist {
  echo "creation storage container $1"
  if [[ $(az storage container list  --account-name $STORAGE_ACCOUNT_NAME --query "[?name=='$1'] | length(@)") > 0 ]]
  then
    echo "Storage Container $1 already exists"
  else
    # Create blob container
    az storage container create --name $1 --account-name $STORAGE_ACCOUNT_NAME --auth-mode login
    echo "Storage Container $1 creation ended with status $?"
    fi
}