#!/bin/sh
die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -eq 1 ] || die "1 argument required (the ScaleUnit name), $# provided"

SCALE_UNIT_NAME="$1"
RESOURCE_GROUP=$(az graph query -q "Resources | where type == 'microsoft.solutions/applications' | where name == '${SCALE_UNIT_NAME}' | project rg = split(parse_json(properties).managedResourceGroupId,'/')[4]" | grep rg | cut -d'"' -f4)
az resource list --resource-group "$RESOURCE_GROUP" --output table