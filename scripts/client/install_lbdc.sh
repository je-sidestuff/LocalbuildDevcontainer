#!/bin/bash

# In this script we create the directory to host the lbdc (such as .devcontainer in vscode)
# and populate the bootstrap script along with any necessary supporting content.

# Initialize variable defaults
if [ -z "$LBDC_WORKING_LOCATION_TYPE" ]; then
    export LBDC_WORKING_LOCATION_TYPE="tmpdir"
fi

if [ -z "$LBDC_INSTALL_LOCATION" ]; then
    export LBDC_INSTALL_LOCATION="$(pwd)"
fi

if [ -z "$LBDC_INSTALL_SOURCE_TYPE" ]; then
    export LBDC_INSTALL_SOURCE_TYPE="git"
fi

if [ -z "$LBDC_INSTALL_TYPE" ]; then
    export LBDC_INSTALL_TYPE="vscode"
fi

# Prepare the working directory as needed
clean_up_working_location () {

    if [ "${LBDC_INSTALL_NOCLEAN_WORKING_DIR}" == "true" ]; then
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

case $LBDC_WORKING_LOCATION_TYPE in

  tmpdir)
    export LBDC_WORKING_LOCATION=$(mktemp -d -t lbdc-install-XXXX)
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

echo "Working directory for LBDC installer: ${LBDC_WORKING_LOCATION}"

# Pull release down into working location
case $LBDC_INSTALL_SOURCE_TYPE in

  git)
    echo "Installing from git source is not yet supported."
    clean_up_working_location
    exit 1
    ;;

  local)
    if [ -z "$LBDC_INSTALL_SOURCE_LOCATION" ]; then
        echo "For local install source type the variable LBDC_INSTALL_SOURCE_LOCATION must be defined."
        clean_up_working_location
        exit 1
    fi
    cp -r $LBDC_INSTALL_SOURCE_LOCATION ${LBDC_WORKING_LOCATION}/LocalbuildDevcontainer
    ;;

  *)
    echo "Unknown install source type: ${LBDC_INSTALL_SOURCE_TYPE}"
    clean_up_working_location
    exit 1
    ;;
esac

# Deploy the lbdc filesystem configuration locally in that release
${LBDC_WORKING_LOCATION}/LocalbuildDevcontainer/scripts/templates/populate_template.sh

# Copy lbdc filesystem configuration into place in the target
for i in `ls -I . -I .. -a ${LBDC_WORKING_LOCATION}/LocalbuildDevcontainer/scripts/bin/`; do
    cp -r ${LBDC_WORKING_LOCATION}/LocalbuildDevcontainer/scripts/bin/$i ${LBDC_INSTALL_LOCATION}
done

# Perform any necessary specific installation routines, such as installing a git submodule

# Clean up any temporary resources which were used
clean_up_working_location
