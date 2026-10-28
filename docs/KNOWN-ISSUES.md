# 已知问题与验证边界

记录日期：2026-10-28。只将本机实际结果标为通过，未将相似上游案例当成已经确诊。

| 项目 | 实际现象 | 当前处理 / 下一步 |
| --- | --- | --- |
| 整机睡眠 | 手动睡眠后黑屏，电源键不能唤醒，曾需强制关机 | 未修复；保留现有禁止系统睡眠策略。锁屏、空闲熄屏测试通过不代表睡眠通过 |
| 内置麦克风 | SOF/PDM 数字输入不可用；原 HDA 输入只有沙沙声 | 现 AppleALC 为输出专用，未修复 DMIC；跨代 SOF 移植已暂停 |
| 失焦窗口黑块 | Finder、终端、Clash Verge 等局部变黑，重新聚焦恢复 | 历史版本下存在；现已更新到 NullMoth 2.6.3，尚未复测此项，不能宣告解决。相似上游问题见下 |
| 外接视频 | USB-C 能枚举屏幕、触摸可用但无画面；HDMI 未正常显示，额外供电也未解决 | 暂停；不能把触摸 USB 通道工作当成视频链路工作 |
| 1280×720 HiDPI | 2.6.3 下 60 / 240 Hz 仍返回1007；普通1280×720@240可用 | 独立保留的问题；不能与已经成功的1600×900/1440×810/1920×1080 HiDPI@240混淆 |
| 刷新率中间档 | 本机有效面板时序只有60/240 Hz | EDID范围60–240不等于存在连续中间档；没有验证自由刷新率方案 |
| Node75 蓝牙键盘 | 能搜到时连接一直转圈，后来也出现搜不到 | 暂停；蓝牙鼠标正常不代表键盘配对通路正常 |
| Photo Booth 预览 | 实时预览可黑屏，但照片与FaceTime有画面 | 摄像头取流可用；预览问题保留，未确定根因 |
| CPU 调度与功耗 | 已看到24逻辑线程及基本变频/空闲状态 | `ctrsmt=full`；不能根据某个GUI“1核”显示判断只工作一核。异构拓扑、最优调度、深度封装休眠与续航未全面验证 |
| 企业无线 | 本机JNU-Secure已通过 | 其他802.1X网络、漫游、睡眠恢复、长期压力测试未完成 |
| 苹果连续互通 | iPhone麦克风在QuickTime可用 | 不承诺iPhone镜像等受硬件/平台限制功能；不通过更换序列号承诺解决 |

## 已解决：所测较大尺寸 HiDPI @240 Hz

2026-10-28，在 Tahoe 26.7.2 + NullMoth 2.6.3 下，1600×900、1440×810、1920×1080 HiDPI @240 Hz 均通过实际模式读回及驱动提交核对。当前使用1600×900@240；长期稳定性与重启保持待验证。详见 [显示验证](DISPLAY.md)。其他未重测问题继续保留。

## 上游案例（相似现象，不等于同一根因）

- 失焦窗口：[NullMoth #120](https://github.com/nullmoth/nvidia-macos-driver/issues/120)、[#73](https://github.com/nullmoth/nvidia-macos-driver/issues/73)、[#92](https://github.com/nullmoth/nvidia-macos-driver/issues/92)。
- 显示缩放：[NullMoth #354](https://github.com/nullmoth/nvidia-macos-driver/issues/354)、[#359](https://github.com/nullmoth/nvidia-macos-driver/issues/359)、[#360](https://github.com/nullmoth/nvidia-macos-driver/issues/360)、[#221](https://github.com/nullmoth/nvidia-macos-driver/issues/221)。
- 旧 IOSurface/wrapper 修改部分已经包含在所用版本中，不能再应用一次当作新修复；像素吞吐阈值只是案例推断，并非已证明的硬件规格。

## 反馈时请提供

主板/CPU/GPU、macOS构建号、驱动版本、是否同一套参数、最小复现步骤，以及必要的已脱敏错误片段。请勿上传完整EFI备份、原始NVRAM、账号、密码、证书私钥、SMBIOS身份、完整IORegistry、认证抓包或包含密钥的日志。
