# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

BASE_ARDUINO_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
BASE_ARDUINO_MK_DIR	:= $(shell dirname $(BASE_ARDUINO_MK_FILE))

ARDUINO_DIR		:= $(shell ls -d ~/.arduino* | grep -E '[0-9]+$$')

ARDUINO_CLI		:= arduino-cli
REMOVE			:= rm -rf
COPY			:= cp

PROJECT			:= $(shell basename `pwd`)
SKETCH			:= $(PROJECT).ino

FQBN			?= $(shell $(ARDUINO_CLI) board list |\
			sed -e '/FQBN/d' |  perl -pe 's/^.+ (\S+:\S+:\S+) .+$$/$$1/')
UPLOAD_PORT		?= $(shell $(ARDUINO_CLI) board list |\
			sed -e '/FQBN/d' |  perl -pe 's/ .+$$//')

SRCS			:= $(wildcard *.ino)

BOARD			:= $(subst :,.,$(FQBN))
BOARD_MK_FILE		:= $(subst :,/,$(FQBN)).mk
FQBN_FLAGS		:= --fqbn $(FQBN)

COMPILE_FLAGS		+= $(FQBN_FLAGS) --export-binaries
COMPILE_FLAGS		+= --clean

UPLOAD_FLAGS		+= $(FQBN_FLAGS) --port $(UPLOAD_PORT)
UPLOAD_FLAGS		+= --verify

BUILD_PATH		:= build/$(BOARD)
OUTPUT			:= $(BUILD_PATH)/$(SKETCH)
BIN_FILE		:= $(OUTPUT).bin
HEX_FILE		:= $(BIN_FILE:.bin=.hex)
MAP_FILE		:= $(BIN_FILE:.bin=.map)

all: info $(ELF_FILE)

info:
	@if [ -z "$(FQBN)" ]; then exit -1; fi
	@echo "[INFO] $(FQBN) , $(UPLOAD_PORT)"

upload: $(ELF_FILE)
	@$(ARDUINO_CLI) upload $(UPLOAD_FLAGS)

clean:
	@rm -rf build
	@rm -rf $(INTERMEDIATES)

$(ELF_FILE): $(SRCS)
	$(ARDUINO_CLI) compile $(COMPILE_FLAGS)

.PHONY: all info upload clean
