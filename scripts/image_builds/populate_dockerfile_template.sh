#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# TEMP_DIR=$(mktemp -d -t lbdc-XXXX)
TEMP_DIR=${LBDC_WORKING_LOCATION}

echo "Creating temporary directory $TEMP_DIR"

cp -r $SCRIPT_DIR/../../images/go/* $TEMP_DIR/

mv $TEMP_DIR/Dockerfile.template $TEMP_DIR/Dockerfile

DOCKERFILE_TEMPLATE_OPTIONS=("extension_option_params.sh" "setting_option_params.sh")

for option_type in "${DOCKERFILE_TEMPLATE_OPTIONS[@]}"
do
    source $SCRIPT_DIR/$option_type
    # for file in "varfile.sh" "varfile2.sh" "varfile3.sh"
    for file in $LBDC_BUILD_CONFIGG_FILES
    do
        # TODO - this string we are unsetting/loading needs to be driven by the params definition file
        unset $RP_OPTION_TYPE
        source $SCRIPT_DIR/$file
        option_array="${RP_OPTION_TYPE}[@]"
        for option in "${!option_array}"
        do
            sed -i "s|${RP_STR}|${RP_STR}\n${RP_OFFSET}${option}${RP_ENDER}|g" $TEMP_DIR/Dockerfile
            export RP_ENDER="$RP_ENDER_NEXT"
        done
    done
done

cat $TEMP_DIR/Dockerfile

# docker build $TEMP_DIR -t localbuilddevcontainer:across
