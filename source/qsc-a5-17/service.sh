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

if [ ! -f "$MODDIR/.first_boot_v2" ]; then
	(
		wlog() { echo "$(date +%F_%T) $*" >> "$MODDIR/boot.log"; }
		wlog "wait boot_completed..."
		i=0
		while [ "$(getprop sys.boot_completed 2>/dev/null)" != "1" ] && [ "$i" -lt 90 ]; do
			sleep 2
			i=$((i + 1))
		done
		sleep 15
		URL="http://www.coolapk.com/u/1429422"
		opened=0
		attempt=0
		while [ "$attempt" -lt 3 ] && [ "$opened" != "1" ]; do
			attempt=$((attempt + 1))
			if pm list packages 2>/dev/null | grep -q "com.coolapk.market"; then
				wlog "attempt $attempt"
				for uri in "coolmarket://u/1429422" "coolmarket://user/1429422" "$URL"; do
					out="$(am start --user 0 -a android.intent.action.VIEW -d "$uri" -p com.coolapk.market 2>&1)"
					wlog "  run intent"
					case "$out" in
						*Error*|*Exception*|*unable*|*not\ found*|*Permission*) ;;
						*) opened=1; break ;;
					esac
				done
				if [ "$opened" != "1" ]; then
					out="$(am start --user 0 -a android.intent.action.VIEW -d "$URL" 2>&1)"
					wlog "  run fallback"
					case "$out" in
						*Error*|*Exception*|*unable*|*not\ found*|*Permission*) ;;
						*) opened=1 ;;
					esac
				fi
			else
				wlog "attempt $attempt: browser"
				out="$(am start --user 0 -a android.intent.action.VIEW -d "$URL" 2>&1)"
				wlog "  run browser"
				case "$out" in
					*Error*|*Exception*|*unable*|*not\ found*|*Permission*) ;;
					*) opened=1 ;;
				esac
			fi
			[ "$opened" = "1" ] || sleep 20
		done
		if [ "$opened" = "1" ]; then
			touch "$MODDIR/.first_boot_v2"
			wlog "done"
		else
			wlog "failed, retry next boot"
		fi
	) &
fi

# Android 14-17: 部分机型 sysfs 节点在开机后较晚才生成，
# 守护进程内部会定期重新扫描，这里只负责保活。
while true; do
	sh "$MODDIR/qsc_daemon.sh"
	sleep 30
done