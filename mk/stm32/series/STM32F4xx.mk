# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

CSRCS			+= syscalls.c
CSRCS			+= sysmem.c
CSRCS			+= system_stm32f4xx.c

CFLAGS			+= -mcpu=cortex-m4
CFLAGS			+= -mfpu=fpv4-sp-d16
CFLAGS			+= -mfloat-abi=hard
CFLAGS			+= -mthumb
