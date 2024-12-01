
# Prepare the working directory as needed
verify_install_success () {

    if [ -f "${LBDC_TEST_DIR}/.devcontainer/devcontainer.json" ]; then
        echo "Successfully installed LBDC in ${LBDC_TEST_DIR}"
    else
        echo "Failed to detect installed devcontainer file."
        exit 1
    fi
}

# Set up temporary testing dir
export LBDC_TEST_DIR=$(mktemp -d -t lbdc-e2e-test-XXXX)
export SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export TEST_LOG="${LBDC_TEST_DIR}/test_log.txt"
cd "${LBDC_TEST_DIR}" # TODO - should not need to change dirs.
echo "Calling ${SCRIPT_DIR}/$( basename ${0})"
echo "Performing end to end test in test dir ${LBDC_TEST_DIR}." | tee -a "${TEST_LOG}"

if [ -z "${LBDC_TEST_TYPE}" ]; then
    export LBDC_TEST_TYPE="local"
fi

if [ "${LBDC_TEST_TYPE}" == "local" ]; then
    export LBDC_INSTALL_SOURCE_TYPE="local"
    export LBDC_INSTALL_SOURCE_LOCATION="${SCRIPT_DIR}/../.."
    export LBDC_INSTALL_NOCLEAN_WORKING_DIR="true"
    echo "Installing from local source:"
    echo " - LBDC_INSTALL_SOURCE_LOCATION : $LBDC_INSTALL_SOURCE_LOCATION"
    echo " - LBDC_INSTALL_NOCLEAN_WORKING_DIR : $LBDC_INSTALL_NOCLEAN_WORKING_DIR"

    # Execute Install Phase
    echo "Calling: ${LBDC_INSTALL_SOURCE_LOCATION}/scripts/client/install_lbdc.sh" | tee -a "${TEST_LOG}"
    bash "${LBDC_INSTALL_SOURCE_LOCATION}/scripts/client/install_lbdc.sh" 2>&1 | tee -a "${TEST_LOG}"

elif [ "${LBDC_TEST_TYPE}" == "git" ]; then
    export LBDC_INSTALL_SOURCE_TYPE="git"
    export LBDC_INSTALL_GIT_LOCATION="feat/first_draft"
    export LBDC_INSTALL_NOCLEAN_WORKING_DIR="true"

    # Execute Install Phase
    wget https://raw.githubusercontent.com/je-sidestuff/LocalbuildDevcontainer/${LBDC_INSTALL_GIT_LOCATION}/scripts/client/install_lbdc.sh
    echo "Calling: ${LBDC_TEST_DIR}/install_lbdc.sh" | tee -a "${TEST_LOG}"
    bash "${LBDC_TEST_DIR}/install_lbdc.sh" 2>&1 | tee -a "${TEST_LOG}"
fi


# Verify
verify_install_success

# Inject Test Hooks for Bootstrap, Load, and Run Phases
cp "${LBDC_INSTALL_SOURCE_LOCATION}/test/e2e/inject/vscode/test_launch.sh" \
    "${LBDC_TEST_DIR}/.devcontainer/launch.sh"

# Run vscode to execute remaining phases (Load, Run) and print cleanup command
if [ "${LBDC_INSTALL_SKIP_run_vscode}" != "true" ]; then
    code .
fi

cd --
