#!/bin/bash

source scripts/utils.sh echo -n

function install_datalad {
	init_venv --name venv --tmp .tmp/
	exit_on_error_code "Failed to init venv"

	datalad --version >/dev/null 2>&1 || python3 -m pip install -r scripts/requirements_datalad.txt
	exit_on_error_code "Failed to install datalad requirements: pip install"
}

datalad --version >/dev/null 2>&1 || install_datalad
exit_on_error_code "Failed to install datalad requirements: pip install"
datalad "$@"
