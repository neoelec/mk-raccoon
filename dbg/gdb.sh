#!/bin/bash
# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

DEBUG_SYMBOL=${1}
TESTFLAGS=${2}

cat <<EOF
file ${DEBUG_SYMBOL}
break main
run ${TESTFLAGS}
EOF

cat $(dirname $(realpath $0))/gdbinit
