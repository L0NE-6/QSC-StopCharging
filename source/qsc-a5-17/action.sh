#!/system/bin/sh
# 模块操作按钮：确保定量停充处于开启状态，并显示当前状态
# （不再用于关闭模块；关闭请运行 关闭定量停充.sh 或创建 off_qsc）
MODDIR=${0%/*}

if [ -f "$MODDIR/off_qsc" ]; then
	rm -f "$MODDIR/off_qsc"
	echo "已开启 QSC 定量停充"
else
	echo "QSC 定量停充已在运行"
fi

state="$(sed -n 's/^description=\[\([^]]*\)\].*/\1/p' "$MODDIR/module.prop" 2>/dev/null | head -n 1)"
[ -n "$state" ] || state="未知"
echo "当前状态: $state"
grep -E '^(power_stop|power_start|power_stop_time|charge_full|power_reset|temperature_switch|temperature_switch_stop|temperature_switch_start)=' "$MODDIR/config.conf" 2>/dev/null
echo "--- 最近日志 ---"
tail -n 6 "$MODDIR/log.log" 2>/dev/null
echo "如需关闭模块: 运行 关闭定量停充.sh"
