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

> 🎯 一句话：**让电池停在你想让它停的地方，而不是永远充到 100%。**
>
> 🔒 本版本已移除原版的联网自更新逻辑，**不联网、不上传、无遥测**，日志与配置全部留在手机本地。

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

也可以到本仓库的 **Releases** 页面下载同样两个包。

---

## 🚀 安装

### 方式一：现代模块版（Android 5.0 ~ 17）

1. 下载 `QSC定量停充_安卓5-17适配版_20261004.zip`；
2. 在 Magisk / KernelSU / ReSukiSU / APatch 管理器中刷入；
3. **重启手机**（重启前 `service.sh` 不会启动，模块不工作）；
4. 配置路径：`/data/adb/modules/QuantitativeStopCharging_switch/config.conf`，日志：同目录 `log.log`。

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
├── dist/                          # 可直接刷入 / 安装的成品包
│   ├── QSC定量停充_安卓5-17适配版_20261004.zip
│   └── QSC定量停充_安卓1-5遗留root实验版.zip
├── source/
│   ├── qsc-a5-17/                 # 现代模块版源码（含 META-INF）
│   └── legacy-root/               # 安卓 1.6-5.x 遗留 root 实验版源码
├── LICENSE
└── README.md
```

---

## 📝 更新日志

### 20261004（R5）

- 现代模块安装器：`customize.sh` + `module.prop` + 官方 recovery `update-binary`，支持管理器安装与 recovery 刷入（Magisk v20.4+）；
- 安装脚本不依赖 Magisk 专有命令，`set_perm` / `ui_print` 缺失时自动回退；
- 全面 toybox 兼容，安卓 5-11 缺少 `awk` 等命令时自动使用 busybox 兜底；
- 配置热重载：`config.conf` 每 3 秒重新读取，修改即时生效；
- **移除原版联网自更新（curl）**，改为本地每 60 秒重新扫描充电开关节点；
- 管理器「执行」按钮改为启用模块 + 显示状态，不再会误触关闭模块；
- 写入失败会记录具体节点，SELinux / 权限问题一眼可见；
- 新增安卓 1.6-5.x 遗留 root 实验版（init.d / install-recovery / SManager）。

---

## ⚠️ 注意事项

- 模块通过写入 `/sys`、`/proc` 下的充电开关节点实现停充，**需要 root**；不同机型节点不同，部分机型内核不暴露可写节点，属于硬件/内核限制，无法通过脚本绕过；
- 请先确认机型支持再长期使用，首次使用建议把阈值调低测试；
- 修改系统节点存在风险，请自行评估并备份重要数据；
- 本模块为本地脚本，不收集、不上传任何数据；诊断日志只保存在手机本地，由你决定是否分享。

---

## 💬 反馈与贡献

遇到问题、有功能建议，或者发现了更好的实现方式，欢迎：

- 提交 **Issue** —— 报 bug、提需求
- 发起 **Pull Request** —— 直接贡献代码

提 Issue 时如果能附上运行日志和复现步骤，定位会快很多 🙏

---

## 🙏 致谢与来源

- 原版 QSC 定量停充：酷安作者 **top大佬**（20231204 版）；
- 本仓库为社区修改 / 适配版本：重构守护脚本、增加安卓 5-17 兼容与安卓 1-5 遗留 root 支持、移除联网自更新、增加诊断脚本；
- 如果原版作者对发布方式有异议，欢迎通过 Issue 联系处理。

## 📄 License

[MIT](LICENSE) © 2026 L0NE-6
