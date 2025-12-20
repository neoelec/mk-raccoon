#!/bin/bash
# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

MODE=${1}
DEBUG_SYMBOL=${2}
TESTFLAGS=${3}

function __gdb_localhost() {
    cat <<EOF
file ${DEBUG_SYMBOL}
break main
run ${TESTFLAGS}
EOF

    cat $(dirname $(realpath $0))/gdbinit
}

function __gdb_remote() {
    cat <<EOF
target remote :2331
file ${DEBUG_SYMBOL}
break main
continue
EOF

    cat $(dirname $(realpath $0))/gdbinit
}

__gdb_${MODE}
