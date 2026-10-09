## v12 — 20261004-v12 (versionCode 2026100416)

- 修复 v11 遗留问题：展锐 `stop_charge` 机型（天翼一号 2021 反馈）用 `dumpsys battery unplug` 隐藏充电标识后，系统电量显示冻结在触发值，模块读不到真实电量、无法按 `power_start` 恢复充电
- 隐藏标识期间改用 sysfs 真实电量做阈值判断，并尝试把真实电量同步回系统显示；恢复充电时 `dumpsys battery reset` 照常执行
- 已实测可用：红米 K40、红米 K50U、小米 14、红米 Note 12 Turbo、小米 17 Pro

完整历史见仓库根目录 `CHANGELOG.md`。
