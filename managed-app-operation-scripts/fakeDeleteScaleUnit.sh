#!/bin/sh
die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -eq 1 ] || die "1 argument required (the ScaleUnit name), $# provided"

SCALE_UNIT_NAME="$1"
echo "Draining scale unit $SCALE_UNIT_NAME event hub and storage account."
sleep 2
echo "Scale unit $SCALE_UNIT_NAME is staged for disbanding."