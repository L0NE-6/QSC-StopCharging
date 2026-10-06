## v9 — 20261004-v9 (versionCode 2026100413)

- 修复小米 17 Pro「写入成功但仍在充电」：仅挂起 `input_suspend` 不会关闭主充电路径
- 改用 MCA `charge_enable` 直接关充电：停止充电写 `qsc all 0`，恢复充电写 `qsc all 1`；`input_suspend` 作为辅助
- 已实测可用：红米 K40、红米 K50U、小米 14、红米 Note 12 Turbo

完整历史见仓库根目录 `CHANGELOG.md`。