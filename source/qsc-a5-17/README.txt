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
   不再会误触把模块关闭；管理器里的「执行」按钮现在点一次开启、再点一次关闭。
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
- "检测到关闭开关，模块暂停"：删除 off_qsc，或再点一次模块「执行」按钮。
- "未找到可用的充电开关节点"：内核没有可写充电开关，跑 probe.sh 发 probe.log。
- "写入停止充电开关: /sys/..." 但电量仍上升：该节点切不断充电，需要按 probe 找新节点。
- "节点写入失败"：SELinux/权限拦截，probe.log 里 writable:no 可确认。
- 什么都没有：确认已重启、模块已启用、电量确实到了 power_stop。

诊断命令（root）：
  su -c sh /data/adb/modules/QuantitativeStopCharging_switch/probe.sh

五、开关模块
------------
- 管理器「执行」按钮：点一次开启，再点一次关闭
- 关闭：创建 /data/adb/modules/QuantitativeStopCharging_switch/off_qsc
- 开启：删除该文件

六、卸载
--------
正常卸载即可：uninstall.sh 会停止守护进程并把常见开关写回允许充电状态。
如仍停在停充状态，重启一次即可（sysfs 状态在重启后复位）。
10. 修复小米14等机型反复充停：不再写入 handle_stop_charging，节点已是目标值时不会重复写入。
11. v5 适配尝试：新增标准 charge_behaviour（auto / inhibit-charge）支持；probe.sh 增加扩展扫描，用于小米17 Pro等新机型定位节点。
12. v6 适配尝试：新增 charge_control_limit 支持（0=停止充电，charge_control_limit_max=恢复充电）；probe.sh 可完整列出 battery / usb / wireless 属性。
13. v7：安装/更新后首次开机自动跳转酷安主页（有酷安 App 直接打开 App，没有则用浏览器打开）。
14. v8：新增小米17 Pro等 MCA 机型支持（xm_power charge_interface input_suspend，qsc all 1/0）；probe 修正 battery/usb/wireless 属性列举并加入 xm_power 节点。
15. v9：小米17 Pro 改用 MCA charge_enable 直接关闭充电（qsc all 0 停充 / qsc all 1 恢复），input_suspend 作为辅助，修复「写入成功但仍在充电」。
16. v10：小米17 Pro 停充后消除充电图标：input_suspend 改用 micharge 客户端投票，系统电池状态上报为 discharging；charge_enable 仍用 qsc 直接关充电。
17. v11：新增 hide_charging_icon（默认自动）：展锐 stop_charge 机型停充后用 dumpsys battery unplug 隐藏充电标识，恢复时 reset。
18. v12：修复展锐 stop_charge 机型「隐藏充电标识后电量显示冻结」：隐藏期间改用 sysfs 真实电量做阈值判断并同步回系统显示；恢复充电时 reset 恢复正常显示。
19. v13：移除温控停充功能；移除 打开定量停充.sh / 关闭定量停充.sh（管理器「执行」按钮点一次开启、再点一次关闭）；清理温度相关与无用变量。
20. v14：修复安装后不跳转酷安：改用新的成功标记（只有打开成功才记录）、增加 --user 0 与三次重试，失败下次开机会继续尝试；日志写入 welcome.log。
