#!/bin/bash
data=$(envsubst < scaleUnit.dat)

out=$(az graph query -q "$data" --query data -o json)
su_array=$(echo "$out" | jq -r ". | map(.resourceGroup) | join(\"','\") | ascii_downcase")
su_rg_array=$(echo "$out" | jq -r ". | map(.name + \",\" + .resourceGroup) | join(\"','\") | ascii_downcase")

export su_array su_rg_array

data=$(envsubst < scaleUnitSlos.dat)

az monitor log-analytics query -w 'd95094a3-db2a-4bd0-9423-a0726090980b' --analytics-query "$data"
