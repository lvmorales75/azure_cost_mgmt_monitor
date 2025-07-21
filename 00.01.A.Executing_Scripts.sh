#!/bin/bash

# Set the path to the variable_specs file
VARIABLE_SPECS_FILE="_in_environment_spec/variables_specs"
BASH_SCRIPTS_DIR="bash"

# 1. Read variable_specs file and set environment variables
if [[ -f "$VARIABLE_SPECS_FILE" ]]; then
    echo "Environment variables before:"
    printenv
    set -a
    source "$VARIABLE_SPECS_FILE"
    set +a
    echo "Eenvironment variables after:"
    printenv
else
    #Try to resolve path form /bash
    VARIABLE_SPECS_FILE="./../_in_environment_spec/variables_specs"
    if [[ -f "$VARIABLE_SPECS_FILE" ]]; then
	echo "Environment variables before:"
    	printenv
        set -a
        source "$VARIABLE_SPECS_FILE"
        set +a
        echo "Eenvironment variables after:"
        printenv
    else
        echo "$VARIABLE_SPECS_FILE not found!"
        exit 1
    fi
fi


