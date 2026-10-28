# 内屏背光与 HiDPI

## 最新验证：2026-10-28

本机已在 **macOS Tahoe 26.7.2（25G332）+ [NullMoth 2.6.3](https://github.com/nullmoth/nvidia-macos-driver/releases/tag/v2.6.3)** 下完成复测。已加载的 NVRM、NVRMFB、NVRMAGDC、NVAccel 均为 2.6.3。此前较高分辨率 HiDPI @240 Hz 的失败，在下面三个所测模式上已解决。

| 逻辑尺寸 | CoreGraphics 像素尺寸 | 刷新率 | 本轮结果 |
| --- | --- | --- | --- |
| 1600×900 HiDPI | 3200×1800 | 240 Hz | 成功；2 秒、5 秒读回一致；当前使用 |
| 1440×810 HiDPI | 2880×1620 | 240 Hz | 成功；2 秒、5 秒读回一致 |
| 1920×1080 HiDPI | 3840×2160 | 240 Hz | 成功；2 秒、10 秒读回一致 |
| 1600×900 HiDPI | 3200×1800 | 60 Hz | 成功，作为对照 |
| 1280×720 HiDPI | 请求 2560×1440 | 60 / 240 Hz | 仍返回 1007，未切换；240 Hz 的两个内部候选均失败 |

物理面板仍为 BOE 2560×1440。较大的 CoreGraphics 像素尺寸表示缩放渲染尺寸，不表示面板变成 4K。当前使用 **1600×900 HiDPI @240 Hz**，本轮为会话级设置，尚未请求永久保存，也未验证重启保持。短时切换成功不等于长期稳定性已经通过。

### 如何确认真正成功

不是仅凭配置 API 返回 0 判断：同时核对 CGS 实际模式、公开 CoreGraphics 当前逻辑/像素尺寸与刷新率，以及驱动 `test -> 1`、`COMMIT -> 1`。1920×1080 的目标 IO 模式 ID 为 `0x80001002`；1600×900 为 `0x80001001`；1440×810 为 `0x80001007`。这些 ID 与索引只作为本轮证据，不能跨版本硬编码。

2.6.2 时 1600×900、1440×810 @240 Hz 的驱动测试返回 `NV_FALSE`，最终为 `kIOReturnUnsupportedMode`（`0xe00002e6`），当前模式不变；并非成功后自动选了 60 Hz。2.6.3 本轮相同 IO 目标的测试和提交均成功。新日志中的源尺寸为 2560×1440，旧日志则为 3200×1800 / 2880×1620；只据日志不能确定内部缩放实现或归因到某一提交，也不能再把旧失败推定为已证明的硬件吞吐上限。

脱敏后的实测字段与代表日志见 [2.6.3 显示验证摘要](../manifests/display-validation-2.6.3.json)。没有上传完整系统日志、IORegistry 或个人显示偏好。

### 剩余边界

- **1280×720 HiDPI 尚未修复**；1280×720 普通非 HiDPI @240 Hz 能用，二者不可混淆。
- 本机模式表仍仅提供 60 / 240 Hz；没有验证 120 / 144 / 165 / 180 Hz、自定义时序或自由刷新率方案。
- 1536×864 等其他尺寸未在 2.6.3 本轮逐一重测，不能将其他尺寸一并标记通过。
- 失焦黑块、Photo Booth 预览、外接视频与睡眠尚未在新版本复测，不能随高刷一起宣告解决。

## 背光与配置

`nvrmacpibl=1` 使本机内屏实际背光可调。原 ACPI GPU 节点提供 NBCI 路径；这与仅覆盖一个通用 PNLF 并不等价。这个开关在某些其他笔记本可能不能使用，保留备用启动入口。

本机使用 `nvfbhidpi=1` 配合已有显示覆盖表与系统模式选择；本轮未新增覆盖条目或自定义时序，不依赖 BetterDisplay Pro 虚拟屏幕镜像。

NVIDIA 系统驱动不在 EFI 中，不能只复制 EFI 就获得显卡加速；按上游说明安装与系统匹配的版本并保留回退条件。本仓库现有 `EFI/` 与发布文件仍是 **Sequoia 15.8.1 基线**，本次未更新为 Tahoe 安装套件。

`DisplayProductID-b7d.sample.plist` 是本机排查过程中保留的显示覆盖**参考样例**，已去除 EDID 序列号，并不保证与最终机器缓存/显示设置完全相同。不自动安装到系统，不包含 WindowServer 个人偏好。

`scripts/set-hidpi-1600x900.rb` 保留历史的 **1600×900 HiDPI @60 Hz 永久保存**行为，本次没有改为 240 Hz 自动设置工具。它依赖私有 CGS 接口、BOE vendor/product 匹配及 `NSHighResolutionCapable=true` 的进程，使用说明见 [构建文档](BUILD.md)。不要将旧脚本当成本轮 240 Hz 测试的重放脚本。

## 历史与上游贡献

Sequoia / NullMoth 2.5.3 与 Tahoe / 2.6.2 阶段，较大尺寸 HiDPI @240 Hz 曾失败，日用退回 1600×900 @60 Hz。这是历史结果，不再代表 2.6.3 的上述模式。

驱动与修复工作归 [nullmoth/nvidia-macos-driver](https://github.com/nullmoth/nvidia-macos-driver) 的维护者和贡献者；本仓库记录本机验证，不把上游修复算作本地驱动补丁。相关讨论：[#354](https://github.com/nullmoth/nvidia-macos-driver/issues/354)、[#360](https://github.com/nullmoth/nvidia-macos-driver/issues/360)、[#221](https://github.com/nullmoth/nvidia-macos-driver/issues/221)。本机测试成功不代表其他机器或上游所有案例已解决。
