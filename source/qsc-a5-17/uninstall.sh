#!/system/bin/sh
# 卸载时停止守护进程，并尽力把常见开关恢复到"允许充电"状态
MODDIR=${0%/*}
dumpsys battery reset >/dev/null 2>&1

if [ -f "$MODDIR/qsc.pid" ]; then
	pid="$(cat "$MODDIR/qsc.pid" 2>/dev/null)"
	if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
		kill "$pid" 2>/dev/null
	fi
fi

for entry in \
	"/sys/class/power_supply/battery/batt_slate_mode:0" \
	"/sys/class/power_supply/battery/store_mode:0" \
	"/sys/class/power_supply/battery/input_suspend:0" \
	"/sys/class/power_supply/battery/charging_enabled:1" \
	"/sys/class/power_supply/battery/charging_enable:1" \
	"/sys/class/power_supply/battery/charge_enable:1" \
	"/sys/class/power_supply/battery/charge_disable:0" \
	"/sys/class/power_supply/usb/input_suspend:0" \
	"/sys/kernel/debug/google_charger/chg_suspend:0" \
	"/sys/kernel/debug/google_charger/chg_mode:1" \
	"/proc/driver/charger_limit_enable:0" \
	"/proc/driver/charger_limit:100" \
	"/proc/mtk_battery_cmd/en_power_path:1"; do
	p="${entry%%:*}"
	v="${entry##*:}"
	[ -e "$p" ] && printf '%s\n' "$v" > "$p" 2>/dev/null
done

rm -f "$MODDIR/qsc.pid" "$MODDIR/power_switch" "$MODDIR/temp_switch" "$MODDIR/now_c" "$MODDIR/off_qsc" "$MODDIR/off_d"
