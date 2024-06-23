#!/bin/bash

# This script makes it so that the .devcontainer initialize command is successful - the array form malfunctions

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

$SCRIPT_DIR/bootstrap_lbdc_loader.sh

$SCRIPT_DIR/.lbdc-cache/scripts/loader/load_lbdc.sh