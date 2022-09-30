################################################################################
# \file program_common.mk
#
# \brief
# Common variables and targets for program.mk
#
################################################################################
# \copyright
# Copyright 2018-2021 Cypress Semiconductor Corporation
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
else
_MTB_RECIPE__OPENOCD_QSPI=-s $(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH)
endif

erase:
	$(MTB__NOISE)echo;\
	echo "Erasing target device... ";\
	$(CY_TOOL_openocd_EXE_ABS) $(_MTB_RECIPE__OPENOCD_ERASE_ARGS)

ifeq ($(MTB_CORE__APPLICATION_BOOTSTRAP),true)
# Multi-core application: pass project-specific program target to the application level
program_application_bootstrap:
	$(MTB__NOISE)$(MAKE) -C .. program

qprogram_application_bootstrap:
	$(MTB__NOISE)$(MAKE) -C .. qprogram

program: program_application_bootstrap
qprogram: qprogram_application_bootstrap
else
# Single-core application: program project image directly
program: program_proj
qprogram: qprogram_proj
endif

program_proj: build_proj qprogram_proj

qprogram_proj: memcalc
ifeq ($(LIBNAME),)
	$(MTB__NOISE)echo;\
	echo "Programming target device... ";\
	$(CY_TOOL_openocd_EXE_ABS) $(_MTB_RECIPE__OPENOCD_PROGRAM_ARGS)
else
	$(MTB__NOISE)echo "Library application detected. Skip programming... ";\
	echo
endif

debug: program_proj qdebug

qdebug: qprogram_proj
ifeq ($(LIBNAME),)
	$(MTB__NOISE)echo;\
	echo ==============================================================================;\
	echo "Instruction:";\
	echo "Open a separate shell and run the attach target (make attach)";\
	echo "to start the GDB client. Then use the GDB commands to debug.";\
	echo ==============================================================================;\
	echo;\
	echo "Opening GDB port ... ";\
	$(CY_TOOL_openocd_EXE_ABS) $(_MTB_RECIPE__OPENOCD_DEBUG_ARGS)
else
	$(MTB__NOISE)echo "Library application detected. Skip debug... ";\
	echo
endif

attach:
	$(MTB__NOISE)echo;\
	echo "Starting GDB Client... ";\
	$(MTB_TOOLCHAIN_GCC_ARM__GDB) $(_MTB_RECIPE__OPENOCD_SYMBOL_IMG) -x $(_MTB_RECIPE__GDB_ARGS)


.PHONY: erase program program_application_bootstrap program_proj
.PHONY: qprogram qprogram_application_bootstrap qprogram_proj debug qdebug attach
