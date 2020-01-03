#!/bin/bash
MODULE_NAME="gslx680_ts_acpi"
KVER=$(uname -r)
MODDESTDIR="/lib/modules/$(KVER)/kernel/drivers/input/touchscreen"
install -p -m 644 "$MODULE_NAME.ko"  "$MODDESTDIR"
/sbin/depmod -a $KVER
