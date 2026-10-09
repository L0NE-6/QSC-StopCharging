#!/system/bin/sh
# QSC installer - Magisk / KernelSU / ReSukiSU / APatch compatible

if ! command -v ui_print >/dev/null 2>&1; then
	ui_print() { echo "$1"; }
fi

if [ -z "$MODPATH" ]; then
	MODPATH="${0%/*}"
fi

qsc_perm() {
	if command -v set_perm >/dev/null 2>&1; then
		set_perm "$1" 0 0 "$2" 2>/dev/null
	else
		chmod "$2" "$1" 2>/dev/null
	fi
}

ui_print " -------------------------- "
ui_print " ------ 安装中，请稍等 ------ "
ui_print " -------------------------- "

for f in qsc_daemon.sh service.sh probe.sh action.sh uninstall.sh; do
	[ -f "$MODPATH/$f" ] && qsc_perm "$MODPATH/$f" 0755
done

qsc_perm "$MODPATH/config.conf" 0644
qsc_perm "$MODPATH/module.prop" 0644


rm -f "$MODPATH/now_c" "$MODPATH/off_d" "$MODPATH/power_on" "$MODPATH/power_off" "$MODPATH/qsc.pid" "$MODPATH/.fail_warn"

if command -v am >/dev/null 2>&1 && command -v pm >/dev/null 2>&1; then
	if [ -n "$(pm list package 2>/dev/null | grep -w 'com.coolapk.market')" ]; then
		am start -d 'coolmarket://u/1429422' >/dev/null 2>&1
	else
		am start -a android.intent.action.VIEW -d 'http://www.coolapk.com/u/1429422' >/dev/null 2>&1
	fi
fi
ui_print " ----- 安装已完成，请重启 ---- "
ui_print " -------------------------- "
