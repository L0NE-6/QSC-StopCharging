# 更新日志

## v11 — 20261004（versionCode 2026100415）

- 新增 `hide_charging_icon`（默认自动）：展锐 `charger.0/stop_charge` 机型停充后，用 `dumpsys battery unplug` 隐藏充电标识，恢复时 `dumpsys battery reset`；
- 解决天翼一号 2021（Unisoc UD710）停充后充电标识不消失的问题；
- `versionCode`：2026100414 → 2026100415。

## v10 — 20261004（versionCode 2026100414）

- 修复小米 17 Pro 停充后充电图标不消失：`input_suspend` 投票改用 `micharge` 客户端，内核会据此把电池状态上报为 `DISCHARGING`，系统充电图标随之消失；
- `charge_enable` 仍用 `qsc` 客户端直接关闭充电；一个负责真正断电，一个负责状态显示；
- 机型反馈：小米 17 Pro 实测确认（停充生效、充电图标随阈值退出）；
- `versionCode`：2026100413 → 2026100414。

## v9 — 20261004（versionCode 2026100413）

- 修复小米 17 Pro「写入成功但仍在充电」：仅挂起 `input_suspend` 只限制了输入，主充电路径仍然开启；
- 改用 MCA `charge_enable` 直接关闭充电：停止充电写 `qsc all 0`，恢复充电写 `qsc all 1`；`input_suspend` 保留为辅助控制；
- `versionCode`：2026100412 → 2026100413。

## v8 — 20261004（versionCode 2026100412）

- 定位小米 17 Pro 根因：其电池驱动的 `charge_control_limit` 是「显示可写但 set 为空」的实现，写入无效；真正的控制接口是 MCA `xm_power` 充电接口；
- 新增 MCA 支持：向 `/sys/class/xm_power/charger/charge_interface/input_suspend` 写入 `qsc all 1` 停止充电、`qsc all 0` 恢复充电；
- `probe.sh` 加入该节点与 `xm_power` 目录列举，并修正 battery / usb / wireless 属性列举（之前 `ls` 未跟随软链接）；
- 机型反馈：红米 Note 12 Turbo 实测可用；
- `versionCode`：2026100411 → 2026100412。

## v7 — 20261004（versionCode 2026100411）

- 安装 / 更新后首次开机自动跳转酷安主页 `https://www.coolapk.com/u/1429422`：检测到酷安 App（`com.coolapk.market`）时优先用 App 打开，未安装则用浏览器打开；
- 跳转只在每次新安装 / 更新后的第一次开机执行一次（`.welcome_shown` 标记）；
- 停充逻辑与 v6 一致（含小米 17 Pro 的 `charge_control_limit` 适配尝试）；
- `versionCode`：2026100410 → 2026100411。

## v6 — 20261004（versionCode 2026100410）

- 尝试适配小米 17 Pro：新增标准 `charge_control_limit` 支持（停止充电写 `0`，恢复充电写 `charge_control_limit_max`，该机为 16）；
- `probe.sh` 按文件权限判断真实可写性（不再被 root 的 `-w` 误判），并完整列出 battery / usb / wireless 的全部属性；
- v5 的 `charge_behaviour` 支持保留；
- `versionCode`：2026100409 → 2026100410。

## v5 — 20261004（versionCode 2026100409）

- 尝试适配小米 17 Pro：新增标准内核接口 `charge_behaviour`（`auto` / `inhibit-charge`）支持，并兼容带 `[当前值]` 的枚举显示；
- `probe.sh` 新增「扩展扫描」：列出 `/sys/class` 顶层、`power_supply` / `qcom-battery` 等目录全部节点，以及所有名字含 charge / batt / suspend 的节点与可写性；
- 小米 14 的反复充停修复保持不变；
- `versionCode`：2026100408 → 2026100409。

## v4 — 20261004（versionCode 2026100408）

- 修复小米 14 反复充电 / 停止：不再写入 `handle_stop_charging`（内核处理节点），避免每 6 秒重复触发；
- 节点已是目标值时跳过写入，只有真正写入时才记录日志，日志不再刷屏；
- 新增已实测机型：小米 14；
- `versionCode`：2026100407 → 2026100408。

## v3 — 20261004（versionCode 2026100407）

- 新增 `updateJson`：刷入 v3 后，可在 Magisk / KernelSU / APatch 管理器里直接检测并更新后续版本；
- 仓库根目录新增 `update.json`（版本清单）和本文件（管理器内更新说明）；
- 模块版本显示改为 `20261004-v3`，`versionCode`：2026100406 → 2026100407；
- v1 / v2 用户需要手动刷一次 v3，之后 v4+ 即可在管理器内更新。

## v2 — 20261004（versionCode 2026100406）

- 新增高通 `qcom-battery/input_suspend` 节点支持（0=恢复充电，1=停止充电），骁龙机型实测可停充：红米 K40、红米 K50U；
- `probe.sh` 与节点扫描同步支持 `/sys/class/qcom-battery`；
- 现代版 `versionCode`：2026100405 → 2026100406。

## v1 — 20261004（versionCode 2026100405）

- 首个发布版本；
- 现代模块安装器，支持 Magisk / KernelSU / ReSukiSU / APatch；
- 配置热重载、移除联网自更新、`probe.sh` 诊断；
- 安卓 1.6-5.x 遗留 root 实验版。
