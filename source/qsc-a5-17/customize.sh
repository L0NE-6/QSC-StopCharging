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

# 独立开关脚本：配合 Anywhere / 快捷方式使用
printf '%s\n' '#!/system/bin/sh' 'rm -f "${0%/*}/off_qsc"' > "$MODPATH/打开定量停充.sh"
printf '%s\n' '#!/system/bin/sh' 'touch "${0%/*}/off_qsc"' > "$MODPATH/关闭定量停充.sh"
qsc_perm "$MODPATH/打开定量停充.sh" 0755
qsc_perm "$MODPATH/关闭定量停充.sh" 0755

rm -f "$MODPATH/now_c" "$MODPATH/off_d" "$MODPATH/power_on" "$MODPATH/power_off" "$MODPATH/qsc.pid" "$MODPATH/.fail_warn"

ui_print " ----- 安装已完成，请重启 ---- "
ui_print " -------------------------- "
