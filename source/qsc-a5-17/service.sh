#!/system/bin/sh
# QSC service: 守护进程，负责在开机后保持定量停充守护脚本存活
# Magisk / KernelSU / ReSukiSU / APatch 通用
MODDIR=${0%/*}

chmod 0755 "$MODDIR/qsc_daemon.sh" 2>/dev/null
chmod 0755 "$MODDIR/probe.sh" 2>/dev/null
chmod 0644 "$MODDIR/config.conf" 2>/dev/null

rm -f "$MODDIR/now_c"

# 已有存活实例则不再启动第二个守护进程（校验 cmdline，避免重启后 PID 复用误判）
if [ -f "$MODDIR/qsc.pid" ]; then
	existing="$(cat "$MODDIR/qsc.pid" 2>/dev/null)"
	if [ -n "$existing" ] && kill -0 "$existing" 2>/dev/null; then
		if [ -r "/proc/$existing/cmdline" ] && tr '\0' ' ' < "/proc/$existing/cmdline" 2>/dev/null | grep -q "qsc_daemon"; then
			exit 0
		fi
	fi
	rm -f "$MODDIR/qsc.pid"
fi

# Android 14-17: 部分机型 sysfs 节点在开机后较晚才生成，
# 守护进程内部会定期重新扫描，这里只负责保活。
while true; do
	sh "$MODDIR/qsc_daemon.sh"
	sleep 30
done
