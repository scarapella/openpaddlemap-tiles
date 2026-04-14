#!/bin/sh
set -ex



cd "$(dirname "$0")"
git pull

gcloud storage cp $PBF_NAME data/sources

CONTAINER_ENGINE=${CONTAINER_ENGINE:-"podman"}

JAVA_CONTAINER_OPTS=
if [ -n "$JAVA_ARGS" ]; then
  JAVA_CONTAINER_OPTS="-e JAVA_TOOL_OPTIONS='$JAVA_ARGS'"
fi

$CONTAINER_ENGINE run $JAVA_CONTAINER_OPTS \
-v "$(pwd)/data":/data \
ghcr.io/onthegomap/planetiler generate-custom \
--osm-path=data/sources/$(basename $PBF_NAME) \
--schema=/data/layers/$SCHEMA.yml \
--output=/data/$SCHEMA.pmtiles \
--storage=RAM --force 
    
gcloud storage cp data/$SCHEMA.pmtiles $TILES_BUCKET_PATH/
