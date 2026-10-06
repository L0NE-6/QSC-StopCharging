QSC 定量停充 - 安卓5-17 适配版（20261004 R5）
================================================

一、支持范围（先说清楚）
------------------------
- 本包（Magisk/KernelSU 模块）：安卓 5.0 - 17。
  * 安卓 5/6-11：需要 Magisk v20.4+（该年代 KernelSU 不存在，用 Magisk）。
  * 安卓 12-17：Magisk / KernelSU / ReSukiSU / SukiSU 分支 / APatch 均可。
- 安卓 1.6 - 5.x（无 Magisk 时代，SuperSU/init.d 老系统）：
  用另一个包 "QSC定量停充_安卓1-5遗留root实验版.zip"，
  需要 root + busybox + 内核暴露可写充电开关节点（实验性，见该包说明）。
- 安卓 1-4 无法使用本模块：Magisk 根本不存在于那个年代，
  这是安装机制的限制，不是脚本能绕过的。

二、这个版本改了什么
--------------------
1. 现代模块安装器（customize.sh + module.prop + 官方 recovery update-binary），
   支持管理器安装，也支持在 TWRP 等 recovery 里刷入（Magisk v20.4+）。
2. 安装脚本不依赖 Magisk 专有命令：set_perm / ui_print 缺失时自动回退。
3. 全面 toybox 兼容，并增加 busybox 兜底：
   安卓 5-11 没有 toybox awk 等命令时自动使用 Magisk/KernelSU 自带 busybox。
4. 配置热重载：config.conf 每 3 秒重新读取，改完立即生效，日志写"配置已更新"。
5. 删除原版联网自更新（curl），改为本地每 60 秒重新扫描充电开关节点。
6. 操作按钮（管理器里的"执行"）改为：启用模块 + 显示状态/配置/日志，
   不再会误触把模块关闭；关闭请用 关闭定量停充.sh。
7. 写入失败会记录具体节点（SELinux/权限问题一眼可见）。
8. 内置高通 qcom-battery/input_suspend 节点（骁龙机型实测可停充）。
9. 支持管理器内更新：内置 updateJson，可在 Magisk / KernelSU / APatch 管理器里直接检测新版本。

三、安装与测试
--------------
1. 在 Magisk / KernelSU / ReSukiSU / APatch 管理器中刷入本 zip。
2. 重启手机（重启前 service.sh 不启动，模块不工作）。
3. 配置：/data/adb/modules/QuantitativeStopCharging_switch/config.conf
   日志：同目录 log.log
4. 默认 100% 停止充电。想早点测试，把 config.conf 改成
   power_stop=80 / power_start=70，保存后 3 秒内生效。

四、停充无效怎么办
------------------
先看 log.log：
- "检测到关闭开关，模块暂停"：删除 off_qsc 或运行 打开定量停充.sh。
- "未找到可用的充电开关节点"：内核没有可写充电开关，跑 probe.sh 发 probe.log。
- "写入停止充电开关: /sys/..." 但电量仍上升：该节点切不断充电，需要按 probe 找新节点。
- "节点写入失败"：SELinux/权限拦截，probe.log 里 writable:no 可确认。
- 什么都没有：确认已重启、模块已启用、电量确实到了 power_stop。

诊断命令（root）：
  su -c sh /data/adb/modules/QuantitativeStopCharging_switch/probe.sh

五、开关模块
------------
- 关闭：创建 /data/adb/modules/QuantitativeStopCharging_switch/off_qsc
- 开启：删除该文件；或运行同目录 打开定量停充.sh / 关闭定量停充.sh
- 管理器"执行"按钮：启用模块并显示状态（不会关闭模块）

六、卸载
--------
正常卸载即可：uninstall.sh 会停止守护进程并把常见开关写回允许充电状态。
如仍停在停充状态，重启一次即可（sysfs 状态在重启后复位）。
10. 修复小米14等机型反复充停：不再写入 handle_stop_charging，节点已是目标值时不会重复写入。
11. v5 适配尝试：新增标准 charge_behaviour（auto / inhibit-charge）支持；probe.sh 增加扩展扫描，用于小米17 Pro等新机型定位节点。
12. v6 适配尝试：新增 charge_control_limit 支持（0=停止充电，charge_control_limit_max=恢复充电）；probe.sh 可完整列出 battery / usb / wireless 属性。
