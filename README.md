<div align="center">

# 🔋 QSC 定量停充

**Magisk / KernelSU / APatch 充电阈值控制模块 · 纯本地脚本 · 无联网**

到达指定电量或温度自动停止充电，低于恢复阈值自动恢复充电 · 配置热重载，改完即生效

<img src="https://img.shields.io/badge/Android-5.0%20~%2017-3DDC84?style=for-the-badge&logo=android&logoColor=white" />
<img src="https://img.shields.io/badge/Magisk-%E2%89%A520.4-00AF9A?style=for-the-badge" />
<img src="https://img.shields.io/badge/KernelSU%20%7C%20APatch-Supported-4EAA25?style=for-the-badge" />
<img src="https://img.shields.io/badge/Shell-POSIX-89E051?style=for-the-badge&logo=gnubash&logoColor=black" />
<img src="https://img.shields.io/badge/Network-None-2088FF?style=for-the-badge" />
<img src="https://img.shields.io/badge/License-MIT-F472B6?style=for-the-badge" />

</div>

---

## ✨ 这是什么

QSC 定量停充是一个运行在 root 环境下的充电控制模块：

- 电量达到 **停止电量**（默认 100%）→ 写入内核充电开关节点，停止充电；
- 电量降到 **恢复电量**（默认 95%）→ 自动恢复充电；
- 电池温度达到 **停止温度**（默认 60℃）→ 停止充电，降到 **恢复温度**（默认 50℃）→ 恢复充电；
- `config.conf` 每 3 秒热重载一次，改完立即生效，不用重启。
- 支持管理器内更新：内置 `updateJson`，在 Magisk / KernelSU / APatch 管理器里可直接检测并安装新版本（v3 起）。

> 🎯 一句话：**让电池停在你想让它停的地方，而不是永远充到 100%。**
>
> 🔒 本版本已移除原版的联网自更新逻辑，**不联网、不上传、无遥测**，日志与配置全部留在手机本地。

## ✅ 已实现机型

以下机型已有实测反馈可用：

| 机型 | 状态 | 说明 |
| :--- | :---: | :--- |
| 红米 K40 | ✅ 可用 | 骁龙平台 `qcom-battery/input_suspend` 节点 |
| 红米 K50U | ✅ 可用 | 骁龙平台 `qcom-battery/input_suspend` 节点 |
| 小米 14 | ✅ 可用 | 骁龙平台 `qcom-battery/input_suspend` 节点；v4 修复反复充停 |
| 红米 Note 12 Turbo | ✅ 可用 | 用户实测反馈可用 |

> 其他骁龙机型如果内核暴露了 `/sys/class/qcom-battery/input_suspend`，也有机会直接可用；欢迎在 Issue 里反馈机型和结果。
>
> ⏳ 适配中：**小米 17 Pro**（v10：`charge_enable` 用 `qsc all 0/1` 直接关充电，`input_suspend` 改用 `micharge` 客户端投票让系统上报 `DISCHARGING`、消除充电图标；等待实机确认）。

---

## 📦 两个版本怎么选

| 版本 | 适用系统 | 安装方式 | 前置条件 |
| :--- | :--- | :--- | :--- |
| **安卓 5-17 适配版** | Android 5.0 ~ 17 | Magisk / KernelSU / APatch 管理器直接刷入 zip | 安卓 5/6-11 需 Magisk ≥ v20.4；安卓 12-17 支持 Magisk / KernelSU / ReSukiSU / SukiSU / APatch |
| **安卓 1-5 遗留 root 实验版** | Android 1.6 ~ 5.x（无 Magisk 时代） | 解压后执行 `install.sh`（SuperSU / init.d / SManager） | 必须已 root + busybox + 内核暴露可写充电开关节点（实验性，多数老机型不支持） |

> ⚠️ 安卓 1-4 无法使用现代模块版：那个年代没有 Magisk，这是安装机制的限制。
> 老系统请先跑 `probe.sh`，只有扫描到 `writable:yes` 的节点才有停充的可能。

### ⬇️ 下载

- [QSC定量停充_安卓5-17适配版_20261004.zip](dist/QSC定量停充_安卓5-17适配版_20261004.zip)
- [QSC定量停充_安卓1-5遗留root实验版.zip](dist/QSC定量停充_安卓1-5遗留root实验版.zip)

也可以到本仓库的 **Releases** 页面下载。发布按版本分开、依次递增：**v1**（首个版本）、**v2**（qcom-battery，红米 K40 / K50U 实测可用）、**v3**（管理器内更新）、**v4**（修复小米 14 反复充停）、**v5**（扩展节点扫描 + `charge_behaviour`）、**v6**（`charge_control_limit` 尝试）、**v7**（安装后跳转酷安主页）、**v8**（MCA `input_suspend` 适配尝试）、**v9**（MCA `charge_enable` 直接关充电）、**v10**（当前版本，修复 17 Pro 停充后充电图标不消失），后续版本继续递增；`dist/` 目录始终是最新版。

---

## 🚀 安装

### 方式一：现代模块版（Android 5.0 ~ 17）

1. 下载 `QSC定量停充_安卓5-17适配版_20261004.zip`；
2. 在 Magisk / KernelSU / ReSukiSU / APatch 管理器中刷入；
3. **重启手机**（重启前 `service.sh` 不会启动，模块不工作）；
4. 配置路径：`/data/adb/modules/QuantitativeStopCharging_switch/config.conf`，日志：同目录 `log.log`。

> 💡 v3 起支持管理器内更新：以后有新版本，直接在 Magisk / KernelSU / APatch 管理器里点更新即可。

### 方式二：遗留 root 实验版（Android 1.6 ~ 5.x）

1. 把 `source/legacy-root/` 里的全部文件传到手机，例如 `/data/local/tmp/qsc/`；
2. 终端执行（root）：

```sh
su -c sh /data/local/tmp/qsc/install.sh
```

3. 安装器会复制文件到 `/data/qsc/`，并尝试安装 init.d 启动项（没有 init.d 时提示用 SManager 等工具开机执行 `sh /data/qsc/boot.sh`）；
4. 重启手机。配置：`/data/qsc/config.conf`，日志：`/data/qsc/log.log`。

---

## ⚙️ 配置说明

编辑 `config.conf`（现代版在模块目录，遗留版在 `/data/qsc/`），保存后 3 秒内自动生效。

| 参数 | 默认值 | 说明 |
| :--- | :---: | :--- |
| `power_stop` | `100` | 停止充电电量，`电量 >= 该值` 时停充；必须大于 `power_start`；填 `110` 可关闭此功能 |
| `power_start` | `95` | 恢复充电电量，`电量 <= 该值` 时恢复；建议与停止电量间隔 5-10 |
| `power_stop_time` | `3` | 触发停充前继续充电的秒数（仅大于 0 的整数）；倒计时开始后无法中止 |
| `charge_full` | `0` | `1` = 充满再停：100% 后等电流小于 100mA 再停充（开启后延时功能自动失效） |
| `power_reset` | `0` | `1` = 每次充电自动拔插一次，用于激活部分机型的快充 |
| `temperature_switch` | `1` | `1` = 开启温控停充 |
| `temperature_switch_stop` | `60` | 电池温度 ≥ 该值（℃）停止充电 |
| `temperature_switch_start` | `50` | 电池温度 ≤ 该值（℃）恢复充电 |

> 想早点测试：把 `power_stop=80`、`power_start=70`，保存后 3 秒内生效。

---

## 🔧 开关与诊断

**临时关闭 / 恢复（现代版）**

- 关闭：创建文件 `/data/adb/modules/QuantitativeStopCharging_switch/off_qsc`
- 恢复：删除该文件，或运行模块目录下的 `打开定量停充.sh` / `关闭定量停充.sh`
- 管理器里的「执行」按钮：启用模块并显示当前状态、配置与最近日志

**临时关闭 / 恢复（遗留版）**

- 关闭：`touch /data/qsc/off_qsc`；恢复：`rm -f /data/qsc/off_qsc`
- 手动启动：`su -c "sh /data/qsc/boot.sh"`；停止：`kill $(cat /data/qsc/qsc.pid)`

**诊断（停充无效时）**

```sh
# 现代版
su -c sh /data/adb/modules/QuantitativeStopCharging_switch/probe.sh

# 遗留版
su -c sh /data/qsc/probe.sh
```

脚本会在模块目录生成 `probe.log`，包含系统版本、机型、电池状态、候选充电节点及可写性，方便定位问题。

---

## ❓ 常见问题

| 现象 | 原因 / 处理 |
| :--- | :--- |
| 日志出现「检测到关闭开关，模块暂停」 | 删除 `off_qsc` 或运行 `打开定量停充.sh` |
| 日志出现「未找到可用的充电开关节点」 | 内核没有暴露可写节点，运行 `probe.sh` 检查 |
| 日志写入了节点但电量仍上升 | 该节点切不断充电，需要按 `probe.log` 找其它节点 |
| 日志出现「节点写入失败」 | SELinux / 权限拦截，`probe.log` 里 `writable:no` 可确认 |
| 停充后电量不下降 | 正常现象，电量不上升即为生效 |
| 完全没有任何日志 | 确认已重启、模块已启用、电量确实达到了 `power_stop` |

---

## 🗂 仓库结构

```
QSC-StopCharging/
├── dist/                          # 可直接刷入 / 安装的成品包（最新版）
│   ├── QSC定量停充_安卓5-17适配版_20261004.zip
│   └── QSC定量停充_安卓1-5遗留root实验版.zip
├── source/
│   ├── qsc-a5-17/                 # 现代模块版源码（含 META-INF）
│   └── legacy-root/               # 安卓 1.6-5.x 遗留 root 实验版源码
├── assets/
│   └── donate/                    # 打赏二维码（支付宝 / 微信）
├── update.json                    # 管理器内更新用的版本清单（updateJson）
├── CHANGELOG.md                   # 更新日志（管理器内也会展示）
├── RELEASING.md                   # 发布流程说明
├── LICENSE
└── README.md
```

---

## 📝 更新日志

<details>
<summary>点击展开完整更新日志</summary>

### v10 — 20261004（versionCode 2026100414）

- 修复小米 17 Pro 停充后充电图标不消失：`input_suspend` 投票改用 `micharge` 客户端，内核会据此把电池状态上报为 `DISCHARGING`，系统充电图标随之消失；
- `charge_enable` 仍用 `qsc` 客户端直接关闭充电；一个负责真正断电，一个负责状态显示；
- `versionCode`：2026100413 → 2026100414。

### v9 — 20261004（versionCode 2026100413）

- 修复小米 17 Pro「写入成功但仍在充电」：仅挂起 `input_suspend` 只限制了输入，主充电路径仍然开启；
- 改用 MCA `charge_enable` 直接关闭充电：停止充电写 `qsc all 0`，恢复充电写 `qsc all 1`；`input_suspend` 保留为辅助控制；
- `versionCode`：2026100412 → 2026100413。

### v8 — 20261004（versionCode 2026100412）

- 定位小米 17 Pro 根因：电池驱动的 `charge_control_limit` 是「显示可写但 set 为空」的实现，写入无效；真正控制充电的是 MCA `xm_power` 接口；
- 新增 MCA 支持：`/sys/class/xm_power/charger/charge_interface/input_suspend` 写入 `qsc all 1` 停止充电、`qsc all 0` 恢复充电；
- `probe.sh` 加入该节点与 `xm_power` 目录列举，并修正 battery / usb / wireless 属性列举；
- `versionCode`：2026100411 → 2026100412。

### v7 — 20261004（versionCode 2026100411）

- 安装 / 更新后首次开机自动跳转酷安主页 `https://www.coolapk.com/u/1429422`：检测到酷安 App（`com.coolapk.market`）时优先用 App 打开，未安装则用浏览器打开；
- 跳转只在每次新安装 / 更新后的第一次开机执行一次（`.welcome_shown` 标记）；
- 停充逻辑与 v6 一致（含小米 17 Pro 的 `charge_control_limit` 适配尝试）；
- `versionCode`：2026100410 → 2026100411。

### v6 — 20261004（versionCode 2026100410）

- 尝试适配小米 17 Pro：新增标准 `charge_control_limit` 支持（停止充电写 `0`，恢复充电写 `charge_control_limit_max`，该机为 16）；
- `probe.sh` 按文件权限判断真实可写性（不再被 root 的 `-w` 误判），并完整列出 battery / usb / wireless 的全部属性；
- v5 的 `charge_behaviour` 支持保留；
- `versionCode`：2026100409 → 2026100410。

### v5 — 20261004（versionCode 2026100409）

- 尝试适配小米 17 Pro：新增标准内核接口 `charge_behaviour`（`auto` / `inhibit-charge`）支持，并兼容带 `[当前值]` 的枚举显示；
- `probe.sh` 新增「扩展扫描」：列出 `/sys/class` 顶层、`power_supply` / `qcom-battery` 等目录全部节点，以及所有名字含 charge / batt / suspend 的节点与可写性；
- 小米 14 的反复充停修复保持不变；
- `versionCode`：2026100408 → 2026100409。

### v4 — 20261004（versionCode 2026100408）

- 修复小米 14 反复充电 / 停止：不再写入 `handle_stop_charging`（内核处理节点），避免每 6 秒重复触发；
- 节点已是目标值时跳过写入，只有真正写入时才记录日志，日志不再刷屏；
- 新增已实测机型：**小米 14**；
- `versionCode`：2026100407 → 2026100408。

### v3 — 20261004（versionCode 2026100407）

- 新增 `updateJson`，在 Magisk / KernelSU / APatch 管理器里可直接检测并更新（v1 / v2 需手动刷一次 v3，之后可在管理器内更新）；
- 新增仓库根目录 `update.json`（版本清单）与 `CHANGELOG.md`；
- 模块版本显示改为 `20261004-v3`，`versionCode`：2026100406 → 2026100407。

### v2 — 20261004（versionCode 2026100406）

- 新增高通 `qcom-battery/input_suspend` 节点支持（0=恢复充电，1=停止充电），骁龙机型实测可停充：**红米 K40、红米 K50U**；
- `probe.sh` 与节点扫描同步支持 `/sys/class/qcom-battery`；
- 现代版 `versionCode`：2026100405 → 2026100406。

### v1 — 20261004（versionCode 2026100405）

- 首个发布版本；
- 现代模块安装器：`customize.sh` + `module.prop` + 官方 recovery `update-binary`，支持管理器安装与 recovery 刷入（Magisk v20.4+）；
- 安装脚本不依赖 Magisk 专有命令，`set_perm` / `ui_print` 缺失时自动回退；
- 全面 toybox 兼容，安卓 5-11 缺少 `awk` 等命令时自动使用 busybox 兜底；
- 配置热重载：`config.conf` 每 3 秒重新读取，修改即时生效；
- **移除原版联网自更新（curl）**，改为本地每 60 秒重新扫描充电开关节点；
- 管理器「执行」按钮改为启用模块 + 显示状态，不再会误触关闭模块；
- 写入失败会记录具体节点，SELinux / 权限问题一眼可见；
- 新增安卓 1.6-5.x 遗留 root 实验版（init.d / install-recovery / SManager）。

</details>
---

## ⚠️ 注意事项

- 模块通过写入 `/sys`、`/proc` 下的充电开关节点实现停充，**需要 root**；不同机型节点不同，部分机型内核不暴露可写节点，属于硬件/内核限制，无法通过脚本绕过；
- 请先确认机型支持再长期使用，首次使用建议把阈值调低测试；
- 修改系统节点存在风险，请自行评估并备份重要数据；
- 本模块为本地脚本，不收集、不上传任何数据；诊断日志只保存在手机本地，由你决定是否分享。

---

## 💬 反馈与贡献

发现 bug、想加功能，或者心里有更好的实现，欢迎直接来：

- **[提交 Issue](https://github.com/L0NE-6/QSC-StopCharging/issues/new)** —— 报 bug、提需求、吐槽都行
- **[发起 Pull Request](https://github.com/L0NE-6/QSC-StopCharging/pulls)** —— 代码说话，改动越具体越好

想让定位快一点，Issue 里可以顺手带上：

- 机型、系统版本，以及用的是哪个版本（安卓 5-17 适配版 / 安卓 1-5 遗留 root 版）
- 相关日志：现代版 `log.log`、`probe.log`；遗留版 `/data/qsc/probe.log`
- 复现步骤，比如“充到 80% 没有停充”就比“用不了”有用得多

---

## ☕ 投喂与打赏

如果这个模块帮你省了心，愿意请我喝杯饮料的话，可以扫下面任意一个码。
完全自愿，不打赏也照常维护和更新。

| <img src="assets/donate/alipay.jpg" alt="支付宝" width="260"> | <img src="assets/donate/wechat.png" alt="微信支付" width="260"> |
| :---: | :---: |
| 支付宝 | 微信支付 |

---

## 🙏 致谢与来源

- 原版 QSC 定量停充：酷安作者 **top大佬**（20231204 版）；
- 本仓库为社区修改 / 适配版本：重构守护脚本、增加安卓 5-17 兼容与安卓 1-5 遗留 root 支持、移除联网自更新、增加诊断脚本；
- 如果原版作者对发布方式有异议，欢迎通过 Issue 联系处理。

## 📄 License

[MIT](LICENSE) © 2026 L0NE-6
