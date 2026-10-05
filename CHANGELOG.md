# 更新日志

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
