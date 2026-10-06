#!/system/bin/sh
# QSC service: 守护进程，负责在开机后保持定量停充守护脚本存活
# Magisk / KernelSU / ReSukiSU / APatch 通用
MODDIR=${0%/*}
PATH="/system/bin:/system/xbin:$PATH"
export PATH

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

# 首次安装/更新后，跳转酷安主页（有酷安 App 用 App，没有则用浏览器）
if [ ! -f "$MODDIR/.welcome_shown" ]; then
	(
		i=0
		while [ "$(getprop sys.boot_completed 2>/dev/null)" != "1" ] && [ "$i" -lt 60 ]; do
			sleep 2
			i=$((i + 1))
		done
		sleep 5
		URL="https://www.coolapk.com/u/1429422"
		if pm list packages 2>/dev/null | grep -q "com.coolapk.market"; then
			opened=0
			for uri in "coolmarket://user/1429422" "coolmarket://u/1429422" "$URL"; do
				out="$(am start -a android.intent.action.VIEW -d "$uri" -p com.coolapk.market 2>&1)"
				case "$out" in
					*Error*|*Exception*|*unable*|*not\ found*) ;;
					*) opened=1; break ;;
				esac
			done
			if [ "$opened" != "1" ]; then
				am start -a android.intent.action.VIEW -d "$URL" >/dev/null 2>&1
			fi
		else
			am start -a android.intent.action.VIEW -d "$URL" >/dev/null 2>&1
		fi
		touch "$MODDIR/.welcome_shown"
	) &
fi

# Android 14-17: 部分机型 sysfs 节点在开机后较晚才生成，
# 守护进程内部会定期重新扫描，这里只负责保活。
while true; do
	sh "$MODDIR/qsc_daemon.sh"
	sleep 30
done
