#!/system/bin/sh
# QSC 遗留 root 安装器（安卓1.6-5.x，SuperSU/init.d 时代）
# 用法：su -c sh /data/local/tmp/qsc/install.sh

SRC=${0%/*}
DST=/data/qsc

BB=""
for p in /system/xbin/busybox /system/bin/busybox /sbin/busybox /data/local/tmp/busybox; do
	[ -x "$p" ] && { BB="$p"; break; }
done
if [ -z "$BB" ]; then
	echo "未找到 busybox，请先把 busybox 安装到 /system/xbin/busybox 再运行本脚本。"
	exit 1
fi

mkdir -p "$DST" "$DST/bin"
cp "$SRC/qsc_daemon.sh" "$DST/qsc_daemon.sh" 2>/dev/null
cp "$SRC/probe.sh" "$DST/probe.sh" 2>/dev/null
cp "$SRC/config.conf" "$DST/config.conf" 2>/dev/null
cp "$SRC/boot.sh" "$DST/boot.sh" 2>/dev/null
chmod 0755 "$DST/qsc_daemon.sh" "$DST/probe.sh" "$DST/boot.sh" 2>/dev/null
chmod 0644 "$DST/config.conf" 2>/dev/null

for a in awk sed grep wc head tr date tail find printf id; do
	rm -f "$DST/bin/$a" 2>/dev/null
	ln -s "$BB" "$DST/bin/$a" 2>/dev/null || "$BB" ln -s "$BB" "$DST/bin/$a" 2>/dev/null
done

INITD=/system/etc/init.d
if [ -d "$INITD" ]; then
	mount -o rw,remount /system 2>/dev/null
	"$BB" mount -o rw,remount /system 2>/dev/null
	if cp "$SRC/99qsc" "$INITD/99qsc" 2>/dev/null; then
		chmod 0755 "$INITD/99qsc" 2>/dev/null
		echo "已安装 init.d 启动项: $INITD/99qsc"
	else
		echo "init.d 存在但写入失败，请手动复制 99qsc 到 $INITD/"
	fi
else
	IR=/system/etc/install-recovery.sh
	if [ -f "$IR" ]; then
		mount -o rw,remount /system 2>/dev/null
		if "$BB" grep -q qsc "$IR" 2>/dev/null; then
			echo "install-recovery.sh 已包含 QSC 启动项"
		else
			echo "[ -x /data/qsc/boot.sh ] && /data/qsc/boot.sh &" >> "$IR" 2>/dev/null
			echo "已追加启动项到 $IR"
		fi
	else
		echo "未找到 init.d / install-recovery.sh。"
		echo "请用 ROM 自带自启功能或 SManager 等工具，开机执行: sh /data/qsc/boot.sh"
	fi
fi

if [ -f "$DST/qsc.pid" ]; then
	oldpid="$(cat "$DST/qsc.pid" 2>/dev/null)"
	if [ -n "$oldpid" ]; then
		kill "$oldpid" 2>/dev/null
	fi
fi
( PATH="$DST/bin:$PATH" sh "$DST/qsc_daemon.sh" >/dev/null 2>&1 & )

echo ""
echo "安装完成。配置: $DST/config.conf  日志: $DST/log.log"
echo "诊断: su -c sh $DST/probe.sh"
