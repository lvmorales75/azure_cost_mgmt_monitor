#!/bin/bash

# Set the path to the variable_specs file
VARIABLE_SPECS_FILE="_in_environment_spec/variables_specs"
BASH_SCRIPTS_DIR="bash"

# 1. Read variable_specs file and set environment variables
source ./00.01.A.Executing_Scripts.sh

# 2. Execute bash scripts from 01 to 03, skipping 02.B and 04
for script in "$BASH_SCRIPTS_DIR"/0[1-3]*.sh; do
    # Skip 02.*.sh and any 04*.sh
    if [[ "$script" == *"/02."*".sh" ]] || [[ "$script" == *"/04"*".sh" ]]; then
        echo "Script: $script - Ignored"
	continue
    elif [[ -x "$script" ]]; then
        echo "Executing $script"
        ./"$script"
    else
        echo "Skipping $script (not executable)"
    fi
done

