#!/bin/bash

# This script is the entrypoint the client normally calls after bootstrapping the loader.
# The scripts configures arguments and version targets for the builder to use, then builds the lbdc,
# and then executes the container if it is not part of an automatic load (such as in VSCode).

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Initialize variable defaults
if [ -z "$LBDC_WORKING_LOCATION_TYPE" ]; then
    export LBDC_WORKING_LOCATION_TYPE="tmpdir"
fi

# Prepare to clean up the working location if necessary
clean_up_working_location () {

    if [ "${LBDC_LOAD_NOCLEAN_WORKING_DIR}" == "true" ]; then
        echo "Leaving LBDC install working directory intact."
        return 0
    fi
  
    case $LBDC_WORKING_LOCATION_TYPE in

    tmpdir)
        rm -rf $LBDC_WORKING_LOCATION
        ;;

    local)
        echo "Installing with local working location is not yet supported."
        exit 1
        ;;

    *)
        echo "Unknown working location type: ${LBDC_WORKING_LOCATION_TYPE}"
        exit 1
        ;;
    esac
}

# Determine and configure working location
case $LBDC_WORKING_LOCATION_TYPE in

  tmpdir)
    export LBDC_WORKING_LOCATION=$(mktemp -d -t lbdc-load-XXXX)
    ;;

  local)
    echo "Installing with local working location is not yet supported."
    exit 1
    ;;

  *)
    echo "Unknown working location type: ${LBDC_WORKING_LOCATION_TYPE}"
    exit 1
    ;;
esac

# Configure lbdc
${SCRIPT_DIR}/configure_lbdc.sh

# Build lbdc
${SCRIPT_DIR}/build_lbdc.sh

# Launch lbdc (if applicable)
if [ "${LBDC_LOAD_LAUNCH}" == "true" ]; then
    ${SCRIPT_DIR}/launch_lbdc.sh
fi
