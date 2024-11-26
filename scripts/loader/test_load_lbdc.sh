#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo -e "Calling ${SCRIPT_DIR}/load_lbdc.sh on $(date) at $(date +%s%3N)\n\n\n" 2>&1 | tee -a "${TEST_LOG}"

"${SCRIPT_DIR}/load_lbdc.sh" 2>&1 | tee -a "${TEST_LOG}"
