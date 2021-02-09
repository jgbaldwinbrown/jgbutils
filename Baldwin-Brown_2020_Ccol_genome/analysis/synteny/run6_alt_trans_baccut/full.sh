#!/bin/bash
set -e

SWD=`pwd`

cd "${SWD}/unedited_input_files" && {
    bash prep_input.sh
}

cd "${SWD}" && {
    bash test.sh
}

cd "${SWD}/reorder" && {
    bash test.sh
}
