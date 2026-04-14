#!/bin/bash
set -x
cd "$(dirname "$0")"

./generate_tiles.sh $@

#cleanup
export ZONE=$(curl -s -H "Metadata-Flavor: Google" http://google.internal | xargs basename)
gcloud compute instances delete $HOSTNAME --zone=$ZONE --quiet
