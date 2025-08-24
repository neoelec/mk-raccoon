# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

SERIES			:= STM32F4xx
FAMILY			:= STM32F411xE
CHIP			:= STM32411vehx

STM32CUBE_TEMPLATE	:= $(STM32CUBE_DIR)/Projects/STM32F411E-Discovery/Templates/STM32CubeIDE

VPATH			+= $(STM32CUBE_TEMPLATE)/Example/Startup
VPATH			+= $(STM32CUBE_TEMPLATE)/Example/User
