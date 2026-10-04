#!/system/bin/sh
# QSC 诊断脚本：安卓1-5遗留系统下停充无效时执行本脚本，把 probe.log 反馈
# 适用于 Magisk / KernelSU / ReSukiSU / APatch
MODDIR=${0%/*}
# ---------------- Android 5-11 兼容：busybox 兜底 ----------------
BUSYBOX=""
for p in /data/adb/magisk/busybox /data/adb/ksu/bin/busybox /system/xbin/busybox /system/bin/busybox /sbin/busybox; do
	[ -x "$p" ] && { BUSYBOX="$p"; break; }
done
if [ -n "$BUSYBOX" ]; then
	BB_BIN="$MODDIR/.bbin"
	mkdir -p "$BB_BIN" 2>/dev/null
	for a in awk sed grep wc head tr date tail find printf; do
		if ! command -v "$a" >/dev/null 2>&1; then
			rm -f "$BB_BIN/$a" 2>/dev/null
			ln -s "$BUSYBOX" "$BB_BIN/$a" 2>/dev/null
		fi
	done
	PATH="$BB_BIN:$PATH"
fi
OUT="$MODDIR/probe.log"

{
	echo "==== QSC probe $(date +%F_%T) ===="
	echo "release=$(getprop ro.build.version.release) sdk=$(getprop ro.build.version.sdk)"
	echo "brand=$(getprop ro.product.brand) model=$(getprop ro.product.model)"
	echo "cpu=$(grep -i Hardware /proc/cpuinfo 2>/dev/null | head -n 1)"
	echo "$(getprop ro.build.display.id)"
	echo "uid=$(id -u 2>/dev/null) selinux=$(getenforce 2>/dev/null)"
	echo "magisk=$(magisk -v 2>/dev/null)"
	echo "ksud=$(ksud -V 2>/dev/null || ksud --version 2>/dev/null)"
	echo "resukisu=$(resukisu -V 2>/dev/null)"
	echo ""
	echo "---------- dumpsys battery ----------"
	dumpsys battery 2>&1
	echo ""
	echo "---------- 候选开关节点 ----------"
	CANDIDATES="/sys/class/power_supply/battery/batt_slate_mode
/sys/class/power_supply/battery/store_mode
/sys/class/power_supply/battery/input_suspend
/sys/class/power_supply/battery/charging_enabled
/sys/class/power_supply/battery/charging_enable
/sys/class/power_supply/battery/charge_enable
/sys/class/power_supply/battery/charge_disable
/sys/class/power_supply/usb/input_suspend
/sys/class/power_supply/idt/pin_enabled
/sys/class/qcom-battery/input_suspend
/sys/kernel/debug/google_charger/chg_suspend
/sys/kernel/debug/google_charger/chg_mode
/proc/driver/charger_limit_enable
/proc/driver/charger_limit
/proc/mtk_battery_cmd/current_cmd
/proc/mtk_battery_cmd/en_power_path
/proc/mtk_charger/en_power_path"
	for f in $CANDIDATES; do
		if [ -e "$f" ]; then
			w="no"
			[ -w "$f" ] && w="yes"
			echo "$f = $(cat "$f" 2>/dev/null) | writable:$w | $(ls -l "$f" 2>/dev/null)"
		fi
	done
	echo ""
	echo "---------- 自动扫描 ----------"
	find /sys/class/power_supply /sys/class/qcom-battery /sys/kernel/debug -maxdepth 3 -type f 2>/dev/null | grep -E -i 'input_suspend|charge.*(enable|disable|stop|suspend)|(enable|disable|stop).*charge|slate_mode|store_mode' | while IFS= read -r f; do
		w="no"
		[ -w "$f" ] && w="yes"
		echo "$f = $(cat "$f" 2>/dev/null) | writable:$w"
	done
	echo ""
	echo "---------- qsc_nodes.log ----------"
	cat "$MODDIR/qsc_nodes.log" 2>/dev/null
	echo ""
	echo "---------- list_switch ----------"
	cat "$MODDIR/list_switch" 2>/dev/null
	echo ""
	echo "---------- log.log 尾部 ----------"
	tail -n 80 "$MODDIR/log.log" 2>/dev/null
} > "$OUT" 2>&1

cat "$OUT"
echo ""
echo "已保存: $OUT"
