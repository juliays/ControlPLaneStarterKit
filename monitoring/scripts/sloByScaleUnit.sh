#!/bin/bash

if [ $# -eq 1 ]
then
   param=$(echo "'$1'" | tr '[:upper:]' '[:lower:]')
   filtering="and name == $param"
   export filtering
   ./listScaleUnitsSlo.sh
else
  echo 'scale unit should be provided as a single parameter'
  exit 1
fi