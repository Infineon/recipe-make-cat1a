################################################################################
# \file program_common.mk
#
# \brief
# Common variables and targets for program.mk
#
################################################################################
# \copyright
# (c) 2018-2024, Cypress Semiconductor Corporation (an Infineon company) or
# an affiliate of Cypress Semiconductor Corporation. All rights reserved.
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

_MTB_RECIPE__OPENOCD_SCRIPTS=-s $(CY_TOOL_openocd_scripts_SCRIPT_ABS)

_MTB_RECIPE__OPENOCD_INTERFACE=source [find interface/kitprog3.cfg];
_MTB_RECIPE__OPENOCD_TARGET=source [find target/$(_MTB_RECIPE__OPENOCD_DEVICE_CFG)];
ifeq ($(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH),)
_MTB_RECIPE__OPENOCD_QSPI=
else ifneq ($(_MTB_RECIPE__NO_QSPI),)
_MTB_RECIPE__OPENOCD_QSPI=
else
_MTB_RECIPE__OPENOCD_QSPI=-s $(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH)
endif

ifneq ($(MTB_PROBE_SERIAL),)
_MTB_RECIPE__OPENOCD_PROBE_SERIAL:=adapter serial $(MTB_PROBE_SERIAL);
_MTB_RECIPE__JLINK_PROBE_SERIAL:=-USB $(MTB_PROBE_SERIAL)
endif

_MTB_RECIPE__PROBE_INTERFACE:=swd
ifneq ($(MTB_PROBE_INTERFACE),)
_MTB_RECIPE__PROBE_INTERFACE:=$(MTB_PROBE_INTERFACE)
endif

ifeq ($(MTB_PROBE_INTERFACE),jtag)
_MTB_RECIPE__JLINK_JTAG_CONF=-JTAGConf -1,-1
endif

ifneq ($(MTB_ERASE_EXT_MEM),)
_MTB_RECIPE__OPENOCD_ERASE_EXT_MEM=$(_MTB_RECIPE__OPENOCD_QSPI)
_MTB_RECIPE__JLINK_ERASE_EXT_MEM:=exec EnableEraseAllFlashBanks
endif

ifeq ($(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR), JLink)
_MTB_RECIPE__GDB_SERVER=$(MTB_CORE__JLINK_GDB_EXE)
_MTB_RECIPE__PROGRAM_ERASE_TOOL=$(MTB_CORE__JLINK_EXE)
_MTB_RECIPE__ERASE_ARGS=-AutoConnect 1 -ExitOnError 1 -NoGui 1 $(_MTB_RECIPE__JLINK_PROBE_SERIAL) -Device $(_MTB_RECIPE__JLINK_DEVICE_CFG_PROGRAM) -If $(_MTB_RECIPE__PROBE_INTERFACE) $(_MTB_RECIPE__JLINK_JTAG_CONF) -Speed auto -CommandFile $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/erase.jlink
_MTB_RECIPE__PROGRAM_ARGS=-AutoConnect 1 -ExitOnError 1 -NoGui 1 $(_MTB_RECIPE__JLINK_PROBE_SERIAL) -Device $(_MTB_RECIPE__JLINK_DEVICE_CFG_PROGRAM) -If $(_MTB_RECIPE__PROBE_INTERFACE) $(_MTB_RECIPE__JLINK_JTAG_CONF) -Speed auto -CommandFile $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/program.jlink
_MTB_RECIPE__DEBUG_ARGS=$(_MTB_RECIPE__JLINK_DEBUG_ARGS)
else
_MTB_RECIPE__GDB_SERVER=$(CY_TOOL_openocd_EXE_ABS)
_MTB_RECIPE__PROGRAM_ERASE_TOOL=$(CY_TOOL_openocd_EXE_ABS)
_MTB_RECIPE__ERASE_ARGS=$(_MTB_RECIPE__OPENOCD_ERASE_ARGS)
_MTB_RECIPE__PROGRAM_ARGS=$(_MTB_RECIPE__OPENOCD_PROGRAM_ARGS)
_MTB_RECIPE__DEBUG_ARGS=$(_MTB_RECIPE__OPENOCD_DEBUG_ARGS)
endif

# Generate command files required by JLink tool for programming/erasing
jlink_generate:
	$(MTB__NOISE)sed "s|&&PROG_FILE&&|$(_MTB_RECIPE__OPENOCD_PROGRAM_IMG)|g;" $(MTB_TOOLS__RECIPE_DIR)/make/scripts/program.jlink > $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/program.jlink
	$(MTB__NOISE)sed "s|&&ERASE_OPTION&&|$(_MTB_RECIPE_JLINK_CMDFILE_ERASE)|g;" $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/program.jlink > $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/_program.jlink
	$(MTB__NOISE)sed "s|&&SECOND_PROG_FILE&&|$(_MTB_RECIPE__OPENOCD_ADDITIONAL_IMG)|g;" $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/_program.jlink > $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/program.jlink
	$(MTB__NOISE)sed "s|&&EXTERNAL_MEM_ERASE&&|$(_MTB_RECIPE__JLINK_ERASE_EXT_MEM)|g;" $(MTB_TOOLS__RECIPE_DIR)/make/scripts/erase.jlink > $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/erase.jlink
	$(MTB__NOISE)sed "s|&&EXTERNAL_MEM_ADDRESS_RANGE&&|$(_MTB_RECIPE__JLINK_ERASE_EXT_MEM_RANGE)|g;" $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/erase.jlink > $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/_erase.jlink
	$(MTB__NOISE)mv -f $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/_erase.jlink $(MTB_TOOLS__OUTPUT_CONFIG_DIR)/erase.jlink

jlink_path_check:
ifeq ($(LIBNAME),)
	$(MTB__NOISE)echo;\
	if [ -z "$(_MTB_RECIPE__PROGRAM_ERASE_TOOL)" ]; then\
		echo "ERROR: Location of J-Link is not set. Use the MTB_JLINK_DIR variable to set the location of the J-Link directory.";\
		echo;\
		exit 1;\
	fi
endif

# depends on $(_MTB_CORE__QBUILD_MK_FILE) to locate flash loaders
erase: $(_MTB_CORE__QBUILD_MK_FILE) erase_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)

erase_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR): debug_interface_check
	$(MTB__NOISE)echo;\
	echo "Erasing target device... ";\
	"$(_MTB_RECIPE__PROGRAM_ERASE_TOOL)" $(_MTB_RECIPE__ERASE_ARGS)

ifeq ($(MTB_CORE__APPLICATION_BOOTSTRAP),true)
# Multi-core application: pass project-specific program target to the application level
program_application_bootstrap:
	$(MTB__NOISE)$(MAKE) -C .. program CY_SECONDSTAGE=

qprogram_application_bootstrap:
	$(MTB__NOISE)$(MAKE) -C .. qprogram CY_SECONDSTAGE=

program: program_application_bootstrap
qprogram: qprogram_application_bootstrap
else
# Single-core application: program project image directly
program: program_proj
qprogram: qprogram_proj
endif

program_proj: program_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)

program_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR): build_proj memcalc

program_JLink qprogram_JLink: jlink_generate jlink_path_check
erase_JLink: jlink_generate

qprogram_proj: qprogram_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)

# depends on $(_MTB_CORE__QBUILD_MK_FILE) to locate flash loaders
program_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR) qprogram_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR): $(_MTB_CORE__QBUILD_MK_FILE) debug_interface_check jlink_generate
ifeq ($(LIBNAME),)
	$(MTB__NOISE)echo;\
	"$(_MTB_RECIPE__PROGRAM_ERASE_TOOL)" $(_MTB_RECIPE__PROGRAM_ARGS)
else
	$(MTB__NOISE)echo "Library application detected. Skip programming... ";\
	echo
endif

debug: program_proj qdebug_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)

qdebug qdebug_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR): qprogram_proj debug_interface_check
ifeq ($(LIBNAME),)
	$(MTB__NOISE)echo;\
	echo ==============================================================================;\
	echo "Instruction:";\
	echo "Open a separate shell and run the attach target (make attach)";\
	echo "to start the GDB client. Then use the GDB commands to debug.";\
	echo ==============================================================================;\
	echo;\
	echo "Opening GDB port ... ";\
	"$(_MTB_RECIPE__GDB_SERVER)" $(_MTB_RECIPE__DEBUG_ARGS)
else
	$(MTB__NOISE)echo "Library application detected. Skip debug... ";\
	echo
endif

attach: debug_interface_check
	$(MTB__NOISE)echo;\
	echo "Starting GDB Client... ";\
	$(MTB_TOOLCHAIN_GCC_ARM__GDB) $(_MTB_RECIPE__OPENOCD_SYMBOL_IMG) -x $(_MTB_RECIPE__GDB_ARGS)


.PHONY: erase program program_application_bootstrap program_proj
.PHONY: qprogram qprogram_application_bootstrap qprogram_proj debug qdebug attach
.PHONY: erase_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR) jlink_generate program_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)
.PHONY: qprogram_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR) debug_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR) qdebug_$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)
