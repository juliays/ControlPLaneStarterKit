#!/bin/sh
die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -eq 1 ] || die "1 argument required (the ScaleUnit name), $# provided"

SCALE_UNIT_NAME="$1"
RESOURCE_GROUP=$(az graph query -q "Resources | where type == 'microsoft.solutions/applications' | where name == '${SCALE_UNIT_NAME}' | project rg = split(parse_json(properties).managedResourceGroupId,'/')[4]" | grep rg | cut -d'"' -f4)
FUNCTION_APP=$(az graph query -q "Resources | where type == 'microsoft.web/sites' | where id contains '${RESOURCE_GROUP}' | project name" | grep name | cut -d'"' -f4)

echo "Restarting '${FUNCTION_APP}' in resource group '${RESOURCE_GROUP}'."
az functionapp restart --name "${FUNCTION_APP}" --resource-group "${RESOURCE_GROUP}"
