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
    # Check for loader cache hit
    GIT_HASH=$(curl -L   -H "Accept: application/vnd.github+json" \
                         -H "X-GitHub-Api-Version: 2022-11-28" \
                         https://api.github.com/repos/je-sidestuff/LocalbuildDevcontainer/commits?sha=feat/first_draft \
                         | tac | tac | head -n 3 | tail -n 1 | cut -d '"' -f 4)

    if [ -f ${SCRIPT_DIR}/.lbdc-cache/git-hash ]; then

      echo "Cached version for $GIT_HASH found."
      if [[ $(< ${SCRIPT_DIR}/.lbdc-cache/git-hash) == $GIT_HASH ]]; then

        echo "Git hash for retrieval matches cache."

        # Verify files as well as git hash
        CHECKSUM=`find ${SCRIPT_DIR}/.lbdc-cache ! -name '*files-csum' -type f -exec md5sum "{}" +`

        if [[ $(< ${SCRIPT_DIR}/.lbdc-cache/files-csum) == $CHECKSUM ]]; then 
            echo "LBDC loader fileset matches cache."
            exit 0
        fi
      fi
    fi

    echo "Retrieving LBDC loader with strategy $LBDC_LOADER_RETRIEVAL_STRATEGY."
    rm -rf ${SCRIPT_DIR}/.lbdc-cache
    mkdir -p ${SCRIPT_DIR}/.lbdc-cache
    curl -L https://github.com/je-sidestuff/LocalbuildDevcontainer/archive/refs/heads/feat/first_draft.zip -o ${SCRIPT_DIR}/.lbdc-cache/lbdc.zip
    unzip ${SCRIPT_DIR}/.lbdc-cache/lbdc.zip -d ${SCRIPT_DIR}/.lbdc-cache/
    rm ${SCRIPT_DIR}/.lbdc-cache/lbdc.zip
    mv ${SCRIPT_DIR}/.lbdc-cache/LocalbuildDevcontainer-feat-first_draft/* ${SCRIPT_DIR}/.lbdc-cache/
    mv ${SCRIPT_DIR}/.lbdc-cache/LocalbuildDevcontainer-feat-first_draft/.* ${SCRIPT_DIR}/.lbdc-cache/
    rm -rf ${SCRIPT_DIR}/.lbdc-cache/LocalbuildDevcontainer-feat-first_draft
    echo -n "$GIT_HASH" > ${SCRIPT_DIR}/.lbdc-cache/git-hash
    
    # Regenerate checksum to include git hash now that is has been written
    CHECKSUM=`find ${SCRIPT_DIR}/.lbdc-cache ! -name '*files-csum' -type f -exec md5sum "{}" +`
    echo -n "$CHECKSUM" > ${SCRIPT_DIR}/.lbdc-cache/files-csum
    ;;

  submodule)
    echo "Installing as a git submodule is not yet supported."
    exit 1
    ;;

  local)
    # Check for loader cache hit
    # TODO - this method works only for filesystem based retrieval strategies
    CHECKSUM=`find $LBDC_LOADER_SOURCE_LOCATION ! -name '*files-csum' -type f -exec md5sum "{}" +`

    # Bring loader into cache if necessary
    if [ -f ${SCRIPT_DIR}/.lbdc-cache/file-csum ]; then

        echo "LBDC loader fileset cache present."

        if [[ $(< ${SCRIPT_DIR}/.lbdc-cache/file-csum) == $CHECKSUM ]]; then 
            echo "LBDC loader fileset matches cache."
            exit 0
        fi
    fi

    echo "Retrieving LBDC loader with strategy $LBDC_LOADER_RETRIEVAL_STRATEGY."
    rm -rf ${SCRIPT_DIR}/.lbdc-cache
    mkdir -p ${SCRIPT_DIR}/.lbdc-cache
    cp -r $LBDC_LOADER_SOURCE_LOCATION/* ${SCRIPT_DIR}/.lbdc-cache
    echo -n "$CHECKSUM" > ${SCRIPT_DIR}/.lbdc-cache/file-csum
    ;;

  *)
    echo "Unknown loader retrieval strategy: ${LBDC_LOADER_RETRIEVAL_STRATEGY}"
    exit 1
    ;;
esac


