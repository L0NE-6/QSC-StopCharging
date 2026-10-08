## v11 — 20261004-v11 (versionCode 2026100415)

- 新增 `hide_charging_icon`（默认自动）：展锐 `charger.0/stop_charge` 机型停充后自动用 `dumpsys battery unplug` 隐藏充电标识，恢复时 `dumpsys battery reset`
- 解决天翼一号 2021（Unisoc UD710）停充后充电标识不消失的问题
- 已实测可用：红米 K40、红米 K50U、小米 14、红米 Note 12 Turbo、小米 17 Pro

完整历史见仓库根目录 `CHANGELOG.md`。