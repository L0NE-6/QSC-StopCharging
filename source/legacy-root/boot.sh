#!/system/bin/sh
# QSC 遗留模式开机启动脚本（供 init.d / SManager / 自启工具调用）
DST=/data/qsc
[ -f "$DST/qsc_daemon.sh" ] || exit 0
PATH="$DST/bin:$PATH"
export PATH
( sh "$DST/qsc_daemon.sh" >/dev/null 2>&1 & )
