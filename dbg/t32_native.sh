#!/bin/bash
# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

DEBUG_SYMBOL=${1}

cat <<EOF
B::
PRIVATE &E_Func &E_Args
ENTRY &E_Func %LINE &E_Args
PRIVATE &ret
&G_RCN_PWD=OS.PresentPracticeDirectory()
ChDir &G_RCN_PWD
&G_RCN_Baremetal_Elf_File="${DEBUG_SYMBOL}"
DO $(dirname $(realpath $0))/t32_native.cmm &E_Func &E_Args
ENTRY &ret
ENDDO &ret
EOF
