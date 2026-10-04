QSC 定量停充 - 安卓1-5 遗留 root 实验版
==========================================

一、适用环境
------------
- 安卓 1.6 - 5.x，且已经 root（SuperSU/授权管理时代）。
- 必须装有 busybox（/system/xbin/busybox 或 /system/bin/busybox）。
- 内核必须暴露一个"可写的充电控制节点"，否则无法停充（见下文）。
- 本包是实验性质：安卓 1-4 时代的手机/内核大多没有充电开关节点，
  probe 扫描不到 writable:yes 的节点，就无法停充，这不是脚本问题。

二、安装
--------
1. 把本目录全部文件传到手机，例如 /data/local/tmp/qsc/
2. 终端执行（root）：
   su -c sh /data/local/tmp/qsc/install.sh
3. 安装器会：
   - 复制文件到 /data/qsc/
   - 用 busybox 建立命令软链接到 /data/qsc/bin/
   - 有 /system/etc/init.d 就装启动项 99qsc
   - 没有 init.d 就尝试追加到 /system/etc/install-recovery.sh
   - 都没有时会在输出里提示用 SManager 等工具开机执行 sh /data/qsc/boot.sh
4. 重启手机。

三、配置与诊断
--------------
- 配置：/data/qsc/config.conf（每 3 秒热重载，改完即生效）
- 日志：/data/qsc/log.log
- 诊断：su -c sh /data/qsc/probe.sh   然后把 probe.log 发出来

四、判断能不能用
----------------
- probe.log 里节点后 writable:yes 且能切到 0/1：有希望停充；
- 全是 writable:no 或没有节点：该内核不支持用户态停充，无法适配；
- 日志出现"写入停止充电开关: /sys/..."但电量仍上升：
  节点写进去了但切不断充电，需要按 probe 结果找其它节点。

五、手动启动/停止
-----------------
- 启动：su -c "sh /data/qsc/boot.sh"
- 停止：kill $(cat /data/qsc/qsc.pid)
- 临时关闭停充：touch /data/qsc/off_qsc
- 恢复：rm -f /data/qsc/off_qsc

六、卸载
--------
su -c sh /data/local/tmp/qsc/uninstall.sh
