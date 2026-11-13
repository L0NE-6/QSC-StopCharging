## v18 — 20261004-v18 (versionCode 2026100422)

- 新增一加 / OPlus ColorOS 充电节点 `mmi_charging_enable`（1=允许充电，0=停止充电）；
- 同时覆盖 `/sys/class/oplus_chg/battery/` 与 `/sys/devices/virtual/oplus_chg/battery/`；
- 修复一加 Ace 2 Pro（ColorOS 16）扫描不到充电开关节点的问题；
- 安卓 5-17 适配版与 1-5 遗留 root 版同步更新。

完整历史见仓库根目录 `CHANGELOG.md`。
