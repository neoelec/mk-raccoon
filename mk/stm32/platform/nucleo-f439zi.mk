# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

SERIES			:= STM32F4xx
FAMILY			:= STM32F439xx
CHIP			:= STM32F439zi

STM32CUBE_TEMPLATE	:= $(STM32CUBE)/Projects/STM324x9I_EVAL/Templates/STM32CubeIDE

VPATH			+= $(STM32CUBE_TEMPLATE)/Example/Startup
VPATH			+= $(STM32CUBE_TEMPLATE)/Example/User
