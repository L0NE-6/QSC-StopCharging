# 更新日志

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
