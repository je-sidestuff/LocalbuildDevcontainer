#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# This script determines the source of truth for the configuration of the lbdc,
# loads the configuration, and populates templates for the build.

# TODO - does this script create the tmpdir or is that outer scope? Thinking outer scope since the build needs the output files.
#      - does this script care to cache? Not yet but probably later.
#      - does this script care to limit internet access for retrieval to ensure re-use? Not yet but probably later.

export LBDC_BUILD_CONFIGG_FILES="varfile.sh varfile2.sh varfile3.sh"

${SCRIPT_DIR}/../image_builds/populate_dockerfile_template.sh
