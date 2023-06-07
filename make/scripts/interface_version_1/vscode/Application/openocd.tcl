source [find interface/kitprog3.cfg]
transport select swd
source [find target/&&_MTB_RECIPE__OPEN_OCD_FILE&&]
${TARGET}.cm0 configure -rtos auto -rtos-wipe-on-reset-halt 1
${TARGET}.cm4 configure -rtos auto -rtos-wipe-on-reset-halt 1
psoc6 sflash_restrictions 1
