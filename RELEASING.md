# 发布流程

每次发布新版本按下面步骤走，保证管理器内更新可用：

1. 修改 `source/qsc-a5-17/module.prop`：
   - `version` 改为 `20261004-vN`
   - `versionCode` 递增（当前为 `2026100414`）
2. 重新打包 `dist/QSC定量停充_安卓5-17适配版_20261004.zip`（至少更新内部的 `module.prop` 与 `README.txt`）。
3. 更新仓库根目录的：
   - `update.json`：`version`、`versionCode`、`zipUrl` 指向新 Release 的 vN 附件
   - `CHANGELOG.md`：补 vN 的更新内容
   - `update-changelog.md`：只写本次 vN 的更新内容（管理器更新弹窗会展示这里）
   - `README.md`：补更新日志
4. 提交并推送 `main`。
5. 创建 Release：
   - tag：`vN`
   - 附件：`QSC-StopCharging_A5-17_vN_20261004.zip`、`QSC-StopCharging_Legacy-Root_vN.zip`
6. 验证：
   - `update.json` 可访问且 JSON 合法
   - `zipUrl` 能正常下载
   - 管理器能识别新的 `versionCode`

> 注意：`updateJson` 只在 v3 及以后的模块里内置，v1 / v2 需要手动刷一次 v3，之后才可以在管理器内更新。
