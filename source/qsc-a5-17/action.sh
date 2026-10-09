#!/system/bin/sh
# 模块操作按钮：点一次开启，再点一次关闭，并显示当前状态
MODDIR=${0%/*}

if [ -f "$MODDIR/off_qsc" ]; then
	rm -f "$MODDIR/off_qsc"
	echo "已开启 QSC 定量停充"
else
	touch "$MODDIR/off_qsc"
	echo "已关闭 QSC 定量停充（再点一次执行恢复）"
fi

state="$(sed -n 's/^description=\[\([^]]*\)\].*/\1/p' "$MODDIR/module.prop" 2>/dev/null | head -n 1)"
[ -n "$state" ] || state="未知"
echo "当前状态: $state"
grep -E '^(power_stop|power_start|power_stop_time|charge_full|power_reset)=' "$MODDIR/config.conf" 2>/dev/null
echo "--- 最近日志 ---"
tail -n 6 "$MODDIR/log.log" 2>/dev/null