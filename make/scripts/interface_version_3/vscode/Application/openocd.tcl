source [find interface/kitprog3.cfg]
&&_MTB_RECIPE__VSCODE_OPENOCD_PROBE_SERIAL_CMD&&
transport select &&_MTB_RECIPE__PROBE_INTERFACE&&
source [find target/&&_MTB_RECIPE__OPEN_OCD_FILE&&]
${TARGET}.cm0 configure -rtos auto -rtos-wipe-on-reset-halt 1
${TARGET}.cm4 configure -rtos auto -rtos-wipe-on-reset-halt 1
&&_MTB_RECIPE__OPENOCD_MONITOR_CMDS_NAME&& sflash_restrictions 1
init//PSoC64 Only//
psoc64.cpu.cm0 arp_examine//PSoC64 Only//
psoc64.cpu.cm4 arp_examine//PSoC64 Only//