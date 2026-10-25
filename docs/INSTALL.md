# 使用与回滚

## 公开文件与实机配置的区别

此仓库不包含Windows/HP/旧Ubuntu的引导文件、macOS系统文件、NVIDIA系统驱动、密码、网络配置描述文件或个人SMBIOS身份。只整理OpenCore所需的子目录。`EFI/BOOT/BOOTx64.efi` 来自与OpenCore.efi匹配的25d02c8官方构建，未复制原内置盘上属于其他系统的fallback引导。

AMFIPass 1.4.1 是原实机启用的依赖，公开发行材料中尚未核实独立来源许可证，因此**没有把该二进制重新分发**。请从 [Dortania/OpenCore-Legacy-Patcher](https://github.com/dortania/OpenCore-Legacy-Patcher) 官方项目核对其AMFIPass材料和使用条件，或从自己已合法取得的同版本副本补齐 `EFI/OC/Kexts/AMFIPass.kext`。不要随意删除已启用的配置项来绕过缺文件检查。它不意味着整套OCLP适合安装到这台黑苹果。

## 准备自己的启动盘

1. 完整备份自己的EFI分区，保留可启动的另一份USB回退。不要覆盖整个分区，更不要删除Microsoft等其他系统目录。
2. 逐项比较硬件和[已知问题](KNOWN-ISSUES.md)，尤其注意无法正常睡眠和内置麦克风不可用。
3. 复制OpenCore目录模板到备用启动盘；补齐AMFIPass及匹配的系统级NullMoth驱动。Wi-Fi公开构建未单独实机验证，建议先在备用盘测试。
4. 参考 [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS) 为自己的机器生成身份，填入 `PlatformInfo/Generic` 的SystemSerialNumber、MLB、SystemUUID、ROM；不要复用别人的身份，也不要公开这些值。
5. 复制 `config.sample.plist` 为 `config.plist`，保持自己需要的USB映射、ACPI和设备路径。该副本被.gitignore排除。
6. 使用同一OpenCore构建的 `ocvalidate` 检查语法，再用 `scripts/validate.py --ready` 检查依赖是否齐全。校验通过不等于硬件兼容。
7. 先从备用盘手动引导，验证图形、键盘、网络、声音，再考虑内置。先关机再拔启动盘，不拔正在运行的系统盘。

## 当前安全与调试参数

模板保留实机已使用的 `debug=0x100`、`keepsyms=1`、AMFI相关放宽、`ipc_control_port_options=0`、SIP设置及NullMoth参数。这些会影响系统安全策略，不能作为通用推荐。为保持可追溯性，本次整理没有擅自删除后重新宣称兼容；使用者应结合上游说明核对自己的需求。没有附带自动关闭安全机制的安装脚本。

## 回滚

保留自己的完整EFI备份和可启动U盘。Wi-Fi问题先从另一份已验证EFI启动，再仅恢复原Wi-Fi驱动；音频问题可只恢复原AppleALC。不要混用本机私人安装脚本里的磁盘UUID，本仓库不发布那些脚本。不要为了恢复网络清空NVRAM或更改校园账号和证书。

EFI快照只包含引导组件，不是完整macOS系统备份；迁移系统与备份EFI是两件事。
