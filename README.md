# HP 暗影精灵 10 乐享版 · i7-14650HX / RTX 4060 Laptop · Hackintosh

这是一台 **HP 暗影精灵 10 乐享版（HP OMEN）**（主板 8CC0 / HM770）的 macOS Sequoia 15.8.1 实机配置与修复记录。维护者：[cells114514](https://github.com/cells114514)。记录截至 **2026-10-25**。

本仓库整理 OpenCore 配置、当前使用的驱动、企业 Wi-Fi 与音频修复源码、上游贡献者，以及仍未解决的问题。**仅这台机器验证过；相同 CPU/GPU 不代表其他笔记本可直接使用。**

> EFI 是去除机器身份的配置模板：先补齐自己的 SMBIOS，再将 `config.sample.plist` 复制为 `config.plist`。AMFIPass 需按 [安装说明](docs/INSTALL.md) 从上游自行取得；NVIDIA 系统驱动需单独安装。不要用本仓库覆盖整个已有 EFI 分区。

## 硬件与基线

| 项目 | 实机基线 |
| --- | --- |
| 电脑 | HP 暗影精灵 10 乐享版（HP OMEN），主板 8CC0，HM770；销售型号由机主确认 |
| CPU | Intel Core i7-14650HX，8P+8E，16 核 / 24 线程 |
| GPU | NVIDIA RTX 4060 Laptop 8 GB，AD107 / PCI 10de:28a0 |
| 内屏 | BOE，2560×1440，原生 60 / 240 Hz；当前 1600×900 HiDPI @60 Hz |
| 无线 | Intel AX211，AirportItlwm 2.4.0 定制分支 |
| 声卡 | 板载 Realtek ALC245；输出由 AppleALC 定制 layout 11 处理 |
| 触控板 | ELAN07C8，I2C 控制器 8086:7A4C |
| 系统 | macOS Sequoia 15.8.1（24H32） |
| SMBIOS 模型 | MacBookPro16,4；所有个人身份字段已清空 |
| OpenCore | 1.0.9 DEBUG，Dortania 构建 25d02c8；OpenCanopy 图形菜单 |
| NVIDIA | NullMoth 2.5.3；不包含系统驱动安装文件，不自动升级 |

## 已验证功能

| 功能 | 验证结果 / 范围 |
| --- | --- |
| 内置 SSD 独立启动 | 已拔掉 Kingston 启动盘并成功从内置 OpenCore 启动 |
| 原生 Wi-Fi 设置 | 系统自带界面可用，无需 HeliPort 常驻 |
| 企业校园网 | JNU-Secure 完成认证，连续十几分钟使用无中断；同步内置 EFI 后重启联网通过 |
| 扬声器 / 3.5 mm 耳机输出 | 定制 AppleALC；耳机插入、国际象棋步数播报回归测试无崩溃 |
| 键盘 / 触控板 | 内置键盘、双指滚动及触控板手势已人工验证 |
| 内屏亮度 | `nvrmacpibl=1` 后可以实际调节 |
| HiDPI | 逻辑 1600×900、渲染 3200×1800、物理 2560×1440，60 Hz；系统保存默认模式 |
| 摄像头 | FaceTime、Photo Booth 拍照有画面；Photo Booth 实时预览仍可能黑屏 |
| 电池 / 接电 | 拔电运行、放电识别、重新接电识别通过 |
| USB / 有线网络 | 用户验证 USB 读写、接口与有线网络正常 |
| 蓝牙基础功能 | 鼠标连接可用；不代表所有设备兼容 |
| 锁屏 / 空闲熄屏 | 已验证；不等于整机睡眠唤醒可用 |
| iPhone 麦克风 | QuickTime 录音正常；语音备忘录录音音量曾异常偏小 |

## 本地修改

- **AirportItlwm 企业认证发送**：关联后启动 BSD 输出 worker；未授权企业端口只允许完整 EAPOL 帧，保留原 RSN 受控端口检查。
- **AirportItlwm 握手完成上报**：真实密钥握手成功、`ni_port_valid` 后，向本机 Sequoia WCL 上报独立 supplicant 事件，解决约十秒后 `4wayHsTimeout` 断线。[原理、证据与边界](docs/WIFI.md)。
- **AppleALC ALC245 输出稳定性**：从 layout 11 删除错误的 HDA 输入端点和相关 ADC/DSP 输入路径，保留扬声器/耳机输出处理；这是避免崩溃的输出方案，**没有修复内置数字麦克风**。[音频说明](docs/AUDIO.md)。
- **VoodooI2C**：在已有 133 MHz 控制器组增加精确的 `7a4c8086` 匹配；保留已验证轮询参数。[触控板差异](patches/VoodooI2C-7A4C-personality.patch)。
- **亮度 / 缩放**：保留 `nvrmacpibl=1`、`nvfbhidpi=1` 和本机已用参数；HiDPI 仍有高刷限制。[显示说明](docs/DISPLAY.md)。

## 尚未解决与未充分验证

详见 [已知问题](docs/KNOWN-ISSUES.md) 和本仓库 Issues。主要剩余：整机睡眠无法唤醒、内置 SOF/PDM 数字麦克风、部分失焦窗口黑块、外接 HDMI/USB-C 视频、高分辨率 HiDPI @240 Hz、Node75 蓝牙配对。企业 Wi-Fi 的睡眠恢复、漫游与长期压力测试未完成。

## 目录

```text
EFI/                  去身份化 OpenCore 模板与可分发组件
Sources/AirportItlwm/  定制 Wi-Fi 完整源码、固件、许可证及 MacKernelSDK
Sources/AppleALC-ALC245/ 定制音频资源
patches/              Wi-Fi 分阶段修改、音频与触控板差异
scripts/              本地构建、校验与显示辅助脚本；不自动写入 EFI
manifests/            组件版本、来源和发布文件 SHA-256
LICENSES/             上游许可证，不用一个统一许可证覆盖所有驱动
```

**重要的构建区别**：实机验证过的是 `eapnotify1` 原始构建；公开 Wi-Fi 二进制由相同源码重建，增加编译路径映射并删除调试映射，以移除本地用户名。公开重建版未单独进行实机启动测试，不能把原构建验证当成字节级相同产物的验证。两者哈希见 [构建清单](manifests/custom-builds.json)。公开 EFI 还进行了身份清理及依赖裁剪，因此属于可审查模板，而不是整盘即用克隆。

## 上游贡献与使用

所有驱动、固件与工具的主要工作归各自上游作者。见 [完整致谢与组件表](docs/CREDITS.md)、[构建说明](docs/BUILD.md)、[安装与回滚](docs/INSTALL.md) 以及 [隐私处理范围](docs/PRIVACY.md)。本项目不是 OpenCore、OpenIntelWireless、Acidanthera 或 NullMoth 的官方版本。反馈本机定制问题请先在本仓库提交 Issue，不把这些修改默认归因于上游。
