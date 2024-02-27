################################################################################
# \file program.mk
#
# \brief
# This make file is called recursively and is used to build the
# resoures file system. It is expected to be run from the example directory.
#
################################################################################
# \copyright
# Copyright 2018-2024 Cypress Semiconductor Corporation
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

ifeq ($(WHICHFILE),true)
$(info Processing $(lastword $(MAKEFILE_LIST)))
endif

include $(MTB_TOOLS__RECIPE_DIR)/make/recipe/program_common.mk

ifeq ($(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR), JLink)
_MTB_RECIPE__GDB_ARGS=$(MTB_TOOLS__RECIPE_DIR)/make/scripts/$(_MTB_RECIPE__JLINK_GDBINIT_FILE)
else
_MTB_RECIPE__GDB_ARGS=$(MTB_TOOLS__RECIPE_DIR)/make/scripts/$(_MTB_RECIPE__OPENOCD_GDBINIT_FILE)
endif

ifeq ($(TOOLCHAIN),A_Clang)
_MTB_RECIPE__OPENOCD_PROGRAM_IMG=$(MTB_TOOLS__OUTPUT_CONFIG_DIR)/$(APPNAME).bin $(TOOLCHAIN_VECT_BASE_CM4)
else
_MTB_RECIPE__OPENOCD_SYMBOL_IMG=$(MTB_TOOLS__OUTPUT_CONFIG_DIR)/$(APPNAME).$(MTB_RECIPE__SUFFIX_TARGET)
_MTB_RECIPE__OPENOCD_PROGRAM_IMG=$(MTB_TOOLS__OUTPUT_CONFIG_DIR)/$(APPNAME).$(MTB_RECIPE__SUFFIX_PROGRAM)
endif

# Multi-core application programming: always use combined HEX image
ifneq ($(_MTB_RECIPE__APP_HEX_FILE),)
_MTB_RECIPE__OPENOCD_PROGRAM_IMG=$(_MTB_RECIPE__APP_HEX_FILE)
endif

# Use custom HEX image when PROG_FILE was provided by the user
ifneq ($(PROG_FILE),)
_MTB_RECIPE__OPENOCD_PROGRAM_IMG=$(PROG_FILE)
endif

ifeq (,$(_MTB_RECIPE__IS_SECURE_DEVICE))
ifeq (,$(_MTB_RECIPE__IS_TVII_DEVICE))
_MTB_RECIPE__OPENOCD_CUSTOM_COMMAND?=psoc6 allow_efuse_program off;
endif
endif

_MTB_RECIPE__OPENOCD_ERASE=init; reset init; $(_MTB_RECIPE__OPENOCD_MONITOR_CMDS_NAME) sflash_restrictions 1; erase_all; exit;
_MTB_RECIPE__OPENOCD_PROGRAM=$(_MTB_RECIPE__OPENOCD_MONITOR_CMDS_NAME) sflash_restrictions 1; program $(_MTB_RECIPE__OPENOCD_PROGRAM_IMG) verify reset exit;
_MTB_RECIPE__OPENOCD_DEBUG=$(_MTB_RECIPE__OPENOCD_CHIP_NAME).cpu.$(_MTB_RECIPE__OPENOCD_CORE) configure -rtos auto -rtos-wipe-on-reset-halt 1; $(_MTB_RECIPE__OPENOCD_EXTRA_PORT_FLAG); init; reset init;

_MTB_RECIPE__OPENOCD_ERASE_ARGS=$(_MTB_RECIPE__OPENOCD_SCRIPTS) -c \
					"$(_MTB_RECIPE__OPENOCD_INTERFACE) $(_MTB_RECIPE__OPENOCD_CM0_DISABLE_FLAG); $(_MTB_RECIPE__OPENOCD_SMIF_DISABLE); $(_MTB_RECIPE__OPENOCD_TARGET) $(_MTB_RECIPE__OPENOCD_CUSTOM_COMMAND) $(_MTB_RECIPE__OPENOCD_ERASE)"
_MTB_RECIPE__OPENOCD_PROGRAM_ARGS=$(_MTB_RECIPE__OPENOCD_SCRIPTS) $(_MTB_RECIPE__OPENOCD_QSPI) -c \
					"$(_MTB_RECIPE__OPENOCD_INTERFACE) $(_MTB_RECIPE__OPENOCD_CM0_DISABLE_FLAG); $(_MTB_RECIPE__OPENOCD_TARGET) $(_MTB_RECIPE__OPENOCD_CUSTOM_COMMAND) $(_MTB_RECIPE__OPENOCD_PROGRAM)"
_MTB_RECIPE__OPENOCD_DEBUG_ARGS=$(_MTB_RECIPE__OPENOCD_SCRIPTS) $(_MTB_RECIPE__OPENOCD_QSPI) -c \
					"$(_MTB_RECIPE__OPENOCD_INTERFACE) $(_MTB_RECIPE__OPENOCD_CM0_DISABLE_FLAG); $(_MTB_RECIPE__OPENOCD_TARGET) $(_MTB_RECIPE__OPENOCD_CUSTOM_COMMAND) $(_MTB_RECIPE__OPENOCD_DEBUG)"

_MTB_RECIPE__JLINK_DEBUG_ARGS=-if swd -device $(_MTB_RECIPE__JLINK_DEVICE_CFG_DEBUG) -endian little -speed auto -port 2331 -swoport 2332 -telnetport 2333 -vd -ir -localhostonly 1 -singlerun -strict -timeout 0 -nogui
