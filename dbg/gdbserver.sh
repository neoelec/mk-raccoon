#!/bin/bash
# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

DEBUG_SYMBOL=${1}

cat <<EOF
target remote :2331
file ${DEBUG_SYMBOL}
EOF

cat $(dirname $(realpath $0))/gdbinit
