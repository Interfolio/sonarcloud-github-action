#!/bin/bash

set -e

if [ ! -d "${INPUT_PROJECT_BASE_DIR}/.scannerwork" ]; then
    echo ".scannerwork directory not found; nothing to clean up."
    exit
fi

_tmp_file=$(ls "${INPUT_PROJECT_BASE_DIR}/" | head -1)
PERM=$(stat -c "%u:%g" "${INPUT_PROJECT_BASE_DIR}/$_tmp_file")

chown -R $PERM "${INPUT_PROJECT_BASE_DIR}/.scannerwork/"

