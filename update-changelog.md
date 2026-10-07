## v10 — 20261004-v10 (versionCode 2026100414)

- 修复小米 17 Pro 停充后“充电图标还在”的问题：`input_suspend` 改用 `micharge` 客户端投票，系统会把电池状态上报为 `DISCHARGING`，图标随之消失
- `charge_enable` 继续用 `qsc` 客户端直接关闭充电（一个负责断电，一个负责状态显示）
- 已实测可用：红米 K40、红米 K50U、小米 14、红米 Note 12 Turbo

完整历史见仓库根目录 `CHANGELOG.md`。