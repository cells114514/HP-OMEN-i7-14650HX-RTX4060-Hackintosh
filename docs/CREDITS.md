# 上游致谢与组件清单

配置和本地修复只占整套工程的一部分。下列维护者及其项目贡献者提供了主要驱动、引导和工具；上游许可证与源文件署名均保留。版本取自实机EFI，不将“最新版本”当作已测试版本。

| 启用的驱动/插件 | 实机版本 | 上游与贡献者 | 本地修改/说明 |
| --- | --- | --- | --- |
| `Lilu.kext` | 1.7.3 | [acidanthera/Lilu](https://github.com/acidanthera/Lilu) | 保留参考配置；插件归属其对应上游 |
| `AMFIPass.kext` | 1.4.1 | [dortania/OpenCore-Legacy-Patcher](https://github.com/dortania/OpenCore-Legacy-Patcher) | Dhinak G.；官方OCLP项目内相关材料；本仓库不重分发二进制 |
| `AppleALC.kext` | 1.9.9 | [acidanthera/AppleALC](https://github.com/acidanthera/AppleALC) | 本机ALC245输出专用资源 |
| `BlueToolFixup.kext` | 2.7.3 | [acidanthera/BrcmPatchRAM](https://github.com/acidanthera/BrcmPatchRAM) | 保留参考配置；插件归属其对应上游 |
| `BrightnessKeys.kext` | 1.0.4 | [acidanthera/BrightnessKeys](https://github.com/acidanthera/BrightnessKeys) | 保留参考配置；插件归属其对应上游 |
| `CpuTopologyRebuild.kext` | 2.0.2 | [b00t0x/CpuTopologyRebuild](https://github.com/b00t0x/CpuTopologyRebuild) | 保留参考配置；插件归属其对应上游 |
| `IntelBTPatcher.kext` | 2.5.0 | [OpenIntelWireless/IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware) | 保留参考配置；插件归属其对应上游 |
| `IntelBluetoothFirmware.kext` | 2.5.0 | [OpenIntelWireless/IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware) | 保留参考配置；插件归属其对应上游 |
| `NVMeFix.kext` | 1.1.4 | [acidanthera/NVMeFix](https://github.com/acidanthera/NVMeFix) | 保留参考配置；插件归属其对应上游 |
| `RealtekRTL8111.kext` | 2.4.2 | [Mieze/RTL8111_driver_for_OS_X](https://github.com/Mieze/RTL8111_driver_for_OS_X) | 保留参考配置；插件归属其对应上游 |
| `RestrictEvents.kext` | 1.1.7 | [acidanthera/RestrictEvents](https://github.com/acidanthera/RestrictEvents) | 保留参考配置；插件归属其对应上游 |
| `VirtualSMC.kext` | 1.3.9 | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC) | 保留参考配置；插件归属其对应上游 |
| `SMCBatteryManager.kext` | 1.3.9 | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC) | 保留参考配置；插件归属其对应上游 |
| `SMCLightSensor.kext` | 1.3.9 | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC) | 保留参考配置；插件归属其对应上游 |
| `SMCProcessor.kext` | 1.3.9 | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC) | 保留参考配置；插件归属其对应上游 |
| `SMCSuperIO.kext` | 1.3.9 | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC) | 保留参考配置；插件归属其对应上游 |
| `USBToolBox.kext` | 1.2.0 | [USBToolBox/kext](https://github.com/USBToolBox/kext) | 保留参考配置；插件归属其对应上游 |
| `UTBMap.kext` | 1.1 | [USBToolBox/tool](https://github.com/USBToolBox/tool) | 参考机器的端口映射，不是通用映射 |
| `VoodooI2C.kext/Contents/PlugIns/VoodooI2CServices.kext` | 1.0 | [VoodooI2C/VoodooI2C](https://github.com/VoodooI2C/VoodooI2C) | Info.plist增加7A4C匹配，原驱动二进制保持 |
| `VoodooI2C.kext/Contents/PlugIns/VoodooGPIO.kext` | 1.1 | [VoodooI2C/VoodooI2C](https://github.com/VoodooI2C/VoodooI2C) | Info.plist增加7A4C匹配，原驱动二进制保持 |
| `VoodooI2C.kext` | 2.9.1 | [VoodooI2C/VoodooI2C](https://github.com/VoodooI2C/VoodooI2C) | Info.plist增加7A4C匹配，原驱动二进制保持 |
| `VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext` | 1.1.7 | [acidanthera/VoodooInput](https://github.com/acidanthera/VoodooInput) | Info.plist增加7A4C匹配，原驱动二进制保持 |
| `VoodooI2CHID.kext` | 1.0 | [VoodooI2C/VoodooI2C](https://github.com/VoodooI2C/VoodooI2C) | 保留参考配置；插件归属其对应上游 |
| `VoodooPS2Controller.kext` | 2.3.8 | [acidanthera/VoodooPS2](https://github.com/acidanthera/VoodooPS2) | 保留参考配置；插件归属其对应上游 |
| `VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Keyboard.kext` | 2.3.8 | [acidanthera/VoodooPS2](https://github.com/acidanthera/VoodooPS2) | 保留参考配置；插件归属其对应上游 |
| `VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext` | 2.3.8 | [acidanthera/VoodooPS2](https://github.com/acidanthera/VoodooPS2) | 保留参考配置；插件归属其对应上游 |
| `VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext` | 2.3.8 | [acidanthera/VoodooPS2](https://github.com/acidanthera/VoodooPS2) | 保留参考配置；插件归属其对应上游 |
| `WhateverGreen.kext` | 1.7.2 | [acidanthera/WhateverGreen](https://github.com/acidanthera/WhateverGreen) | 保留参考配置；插件归属其对应上游 |
| `XHCI-unsupported.kext` | 0.9.2 | [RehabMan/OS-X-USB-Inject-All](https://github.com/RehabMan/OS-X-USB-Inject-All) | 保留参考配置；插件归属其对应上游 |
| `AirportItlwm.kext` | 2.4.0 | [laobamac/itlwm](https://github.com/laobamac/itlwm) | laobamac Sequoia 分支；本机企业认证/通知修改，公开版路径脱敏重建 |

## 引导、图形与辅助工具

| 项目 | 上游 / 贡献者 | 使用范围 |
| --- | --- | --- |
| OpenCore / OpenCanopy / ocvalidate | [acidanthera/OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)；[Dortania构建25d02c8](https://github.com/dortania/build-repo/releases/tag/OpenCorePkg-25d02c8) | 实机1.0.9 DEBUG与同构建图形菜单/校验器 |
| 图形菜单资源 | [acidanthera/OcBinaryData](https://github.com/acidanthera/OcBinaryData) | GoldenGate、字体和标签；保留原资源权属 |
| NVIDIA系统驱动 | [nullmoth/nvidia-macos-driver](https://github.com/nullmoth/nvidia-macos-driver) | 实机2.5.3，NVRM/NVRMFB/NVAccel；不分发系统安装包 |
| 引导/恢复工具 | [nullmoth/1401](https://github.com/nullmoth/1401) | 原工程与NullMothSafe恢复入口；上游非商业许可需遵守 |
| Intel固件与驱动祖先 | [OpenIntelWireless/itlwm](https://github.com/OpenIntelWireless/itlwm) | laobamac分支基础；保留Intel firmware license、BSD/net80211等源文件声明 |
| MacKernelSDK | [acidanthera/MacKernelSDK](https://github.com/acidanthera/MacKernelSDK) | 固定3f750085…构建依赖；包含Apple APSL等原始声明 |
| HeliPort | [OpenIntelWireless/HeliPort](https://github.com/OpenIntelWireless/HeliPort) | 前期itlwm无线测试；当前原生Wi-Fi方案无需常驻 |
| BetterDisplay | [waydabber/BetterDisplay](https://github.com/waydabber/BetterDisplay) | 前期HiDPI/虚拟屏幕诊断；当前日用不依赖Pro虚拟镜像 |
| 鼠标平滑滚动 | [AprilNEA/OpenLogi](https://github.com/AprilNEA/OpenLogi) | 实机0.8.17开启smooth_scroll后滚轮体验改善；不分发用户配置 |
| ACPI查看/编译 | [acidanthera/MaciASL](https://github.com/acidanthera/MaciASL)、[ACPICA](https://github.com/acpica/acpica) | 使用iasl分析本机ACPI |
| 身份与配置工具 | [corpnewt/GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)、[ProperTree](https://github.com/corpnewt/ProperTree) | 参考工具；不分发个人身份或其应用包 |
| 构建工具 | [Apple Xcode](https://developer.apple.com/xcode/) | 实际编译Xcode16.4；不上传SDK安装包 |
| 安装/维护参考 | [Dortania OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/) | 社区参考文档；本机新平台/独显仍需专门适配 |

## 只研究，未部署的麦克风项目

[pokipoi/LatSOF-Audio](https://github.com/pokipoi/LatSOF-Audio)、[shubhambanekar/LatSOFAudio](https://github.com/shubhambanekar/LatSOFAudio)、[Sound Open Firmware](https://github.com/thesofproject/sof) 与 [sof-bin](https://github.com/thesofproject/sof-bin)。其他代际的工作成果不表示本机已支持。

## 许可证

`LICENSES/`保存已取得的上游许可证；个别聚合仓库、资源或固件不能仅用GitHub自动识别的单个许可证概括，应继续查阅原项目和逐文件声明。本仓库没有将所有第三方组件重新授权为MIT。
