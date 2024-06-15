#!/bin/bash

# In this script we remove and re-create the directory where populated templates are deployed for a new lbdc install.
# Once this script finishes the static filesystem resources will be ready to be copied into the lbdc install location.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Copy the templates into the re-created bin directory
rm -rf ${SCRIPT_DIR}/../bin
mkdir ${SCRIPT_DIR}/../bin
for i in `ls -I . -I .. -a ${SCRIPT_DIR}/${LBDC_INSTALL_TYPE}/`; do
    cp -r ${SCRIPT_DIR}/${LBDC_INSTALL_TYPE}/$i ${SCRIPT_DIR}/../bin/
done

# Copy universal files (TODO - this should read a config, not know about files)
cp ${SCRIPT_DIR}/../client/bootstrap_lbdc_loader.sh ${SCRIPT_DIR}/../bin/.devcontainer/

# TODO - the repo config values need to be driven
cp ${SCRIPT_DIR}/config/lbdc_repo_config.sh ${SCRIPT_DIR}/../bin/

# Perform in-place replacements (TODO - this should detect and traverse, not know about files)
sed -i 's/REPLACE_LBDC_TAG/latest/g' ${SCRIPT_DIR}/../bin/.devcontainer/Dockerfile
