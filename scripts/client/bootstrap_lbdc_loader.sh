#!/bin/bash

# In this script we resolve the version of the LBDC loader and the means by which to obtain it.
# This script will be deployed into a directory along with the configuration 

# Load configuration
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# TODO - this location - will it be the same if we are doing a non-vscode install?
source ${SCRIPT_DIR}/../lbdc_repo_config.sh

# Find retrieval strategy (local, gitfile, submodule)
case $LBDC_LOADER_RETRIEVAL_STRATEGY in

  gitfile)
    echo "Installing from git source is not yet supported."
    exit 1
    ;;

  submodule)
    echo "Installing from git source is not yet supported."
    exit 1
    ;;

  local)
    # TODO - call checksum check from here?
    ;;

  *)
    echo "Unknown loader retrieval strategy: ${LBDC_LOADER_RETRIEVAL_STRATEGY}"
    exit 1
    ;;
esac

# Check for loader cache hit
# TODO - this method works only for filesystem based retrieval strategies
CHECKSUM=`find $LBDC_LOADER_SOURCE_LOCATION -type f -exec md5sum "{}" +`

# Bring loader into cache if necessary
if [ -f ${SCRIPT_DIR}/.lbdc-cache-csum ]; then
    if [[ $(< ${SCRIPT_DIR}/.lbdc-cache-csum) == $CHECKSUM ]]; then 
        echo "LBDC loader is already cached."
        exit 0
    fi
fi

echo "Retrieving LBDC loader."
mkdir -p ${SCRIPT_DIR}/.lbdc-cache
cp -r $LBDC_LOADER_SOURCE_LOCATION/* ${SCRIPT_DIR}/.lbdc-cache
echo -n "$CHECKSUM" > ${SCRIPT_DIR}/.lbdc-cache-csum
