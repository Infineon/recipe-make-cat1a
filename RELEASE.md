# PSOC™ 6 GNU make Build System Release Notes
This repo provides the build recipe make files and scripts for building and programming PSOC™ 6 applications. Builds can be run either through a command-line interface (CLI) or through a supported IDE such as Eclipse or VS Code.

### What's Included?
This release of the PSOC™ 6 GNU make build recipe includes complete support for building, programming, and debugging PSOC™ 6 application projects. It is expected that a code example contains a top level make file for itself and references a Board Support Package (BSP) that defines specific items, like the PSOC™ 6 part, for the target board. Supported functionality includes the following:

* Supported operations:
    * Build
    * Program
    * Debug
    * IDE Integration (Eclipse, VS Code, IAR, uVision)
* Supported toolchains:
    * GCC
    * IAR
    * ARM Compiler 6
    * LLVM Embedded Toolchain for Arm (Experimental)

### What Changed?
#### v2.6.0
* Fixed inability to Attach to PSOC6 MCU running FreeRTOS application due to 'Cannot execute this command without a live selected thread'

#### v2.5.0
* Moved CFLAGS, CXXFLAGS, ASFLAGS, LDFLAGS variables to be added after default flags. In case of conflict, most toolchains select the last flags as the option. This allows those variables to overwrite the default flags.
* Added support for GNU assembly syntax when using ARM toolchain.

#### v2.4.0
* Added Ninja support. Ninja build will be enabled by default with ModusToolbox 3.4, and latest core-make. To disable Ninja build set NINJA to empty-String. (For example: "make build NINJA=").

#### v2.3.1
* Fixed a postbuild dependency that could cause memcalc to fail.

#### v2.3.0
* Experimental support for LLVM Embedded Toolchain for Arm.
* Optimization for speed changed to optimization for size for the IAR toolchain.
* The feature of setting the default location of the ARM and IAR toolchains has been deprecated.
* Added support for Infineon EdgeProtectTool.
* Added task in VS Code export's tasks.json in multicore application to only build the current project.
* Added option for Eclipse export to only build the current project in multicore application.
* Added launch configurations for Eclipse and VS Code to only program/debug a single project in multi-core application.
* Added a "last_config" build configuration directory that contains the hex file and elf file from last build.
* VS Code and Eclipse launch configurations now use "last_config" directory. Launch configurations no longer have to be re-generated when switching between "Debug" and "Release".

#### v2.2.1
* Minor update to support export into uVision IDE for new CMSIS Device Family Pack.

#### v2.2.0
* Improved multi-project applications support.

#### v2.1.2
* Added programming and debugging support for Traveo II B-E.

#### v2.1.1
* Added support for BSP_PROGRAM_INTERFACE to select debug interface. Valid values are "KitProg3" and "JLink". Default value is "KitProg3".
* Eclipse and VS Code export will now only generate the launch configuration for the selected programming interface.

#### v2.0.0
* Major version update. Significant changes to support ModusToolbox 3.0
* Dropped compatibility with core-make version 1.X and ModusToolbox tools version 2.X

#### v1.9.0
* Various minor improvements for path handling

#### v1.8.0
* Added support for cys06xxa linker script
* Updated launch configs for PSoC6 256K devices
* Fixed a compatibility bug introduced with make vscode in core-make-1.8.0

#### v1.7.2
* Fix an issue causing make bsp to not include co-processor into custom bsp's design.modus

#### v1.7.1
* Fix an issue with make progtool
* Improved Eclipse and VS Code launch configurations

#### v1.7.0
* Added ml-configurator

#### v1.5.1
* Fixed bug in PSoC 6 CM0+ Eclipse programming launch config file

#### v1.5.0
* Added support for finding patched versions of the ModusToolbox tools
* Added support for .mtb files
* Improved support for sharing code between projects

#### v1.4.1
* Added support for PSoC 6 S2 & S3 single core devices
* Fixed timing problem starting debugger for some PSoC 64 parts

#### v1.4.0
* Improved compatibility with MTB 2.0 and 2.1 tools
* Improved support for J-Link
* Improved support for different toolchains in VS Code
* Improved support for PSoC 64 based boards
* Fixed issue with output formatting on Mac

#### v1.3.1
* Updated IAR to include '--threaded\_lib' when building for FreeRTOS.
NOTE: This requires the IAR System lock functions to be defined. Implementations for these are provided by the [clib-support](https://github.com/Infineon/clib-support) library.

#### v1.3.0
* Separated build process into two stages to improve robustness
* Added support for building dependent apps for CM0+ & MCU Boot
* Added support for exporting to uvision5

#### v1.2.1
* Added support for PSoC 64 S3 parts
* Improved description for some targets

#### v1.2.0
* Added support for generating new BSPs
* Added support for launching Library Manager
* Added support for integrating with Embedded Workbench (beta)
* Improved support for integrating with Eclipse
* Improved file discovery performance

#### v1.1.0
* Improved support for Multi-Core boards
* Minor Bug fixes

#### v1.0.1
* Minor improvement for vscode target

#### v1.0.0
* Initial release supporting build/program/debug on gcc/iar/armv6 toolchains

### Product/Asset Specific Instructions
Builds require that the ModusToolbox tools be installed on your machine. This comes with the ModusToolbox install. On Windows machines, it is recommended that CLI builds be executed using the Cygwin.bat located in ModusToolBox/tools\_x.y/modus-shell install directory. This guarantees a consistent shell environment for your builds.

To list the build options, run the "help" target by typing "make help" in CLI. For a verbose documentation on a specific subject type "make help CY\_HELP={variable/target}", where "variable" or "target" is one of the listed make variables or targets.

### Supported Software and Tools
This version of the PSOC™ 6 build system was validated for compatibility with the following Software and Tools:

| Software and Tools                        | Version |
| :---                                      | :----:  |
| ModusToolbox Software Environment         | 3.5     |
| GCC Compiler                              | 11.3    |
| IAR Compiler                              | 9.3     |
| ARM Compiler                              | 6.16    |

Minimum required ModusToolbox Software Environment: v3.4

### More information
* [Infineon GitHub](https://github.com/Infineon)
* [ModusToolbox](https://www.infineon.com/cms/en/design-support/tools/sdk/modustoolbox-software)

---
(c) 2019-2025, Cypress Semiconductor Corporation (an Infineon company) or an affiliate of Cypress Semiconductor Corporation. All rights reserved.
