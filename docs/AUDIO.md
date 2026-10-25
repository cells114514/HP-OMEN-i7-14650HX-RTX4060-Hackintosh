# ALC245 输出稳定性修复

基线为 [acidanthera/AppleALC @ff01db21749271916d44605503499ceaa61d94b2](https://github.com/acidanthera/AppleALC/tree/ff01db21749271916d44605503499ceaa61d94b2)，1.9.9。编译用 Lilu 1.7.2 DEBUG 头文件；系统继续使用 Lilu 1.7.3，未替换为编译依赖版。

本机插入不带麦克风的 3.5 mm 耳机，以及国际象棋自动播报时出现过崩溃。内置数字麦克风也曾只有均匀沙沙声；切换另一个 layout 使输入设备消失，并未修复。

当前定制只修改 ALC245 的两个资源：

- `layout11.xml` 删除 Mic / LineIn 及 Inputs 端点。
- `Platforms11.xml` 删除对应 ADC 输入组和 Microphone peripheral DSP。
- 保留扬声器、耳机输出路径及原有输出 EQ/限幅等处理；未简单删除全部 DSP。

资源经源码编译嵌入，实机回归耳机插入和国际象棋播报不再崩溃。内置数字麦克风仍未修复，输出专用配置可能不发布任何 HDA 输入，这属于设计结果。建议需要输入时使用已验证的 iPhone/QuickTime 或另行测试 USB 麦克风。

SOF/PDM 麦克风研究参考 [pokipoi/LatSOF-Audio](https://github.com/pokipoi/LatSOF-Audio) 与 [shubhambanekar/LatSOFAudio](https://github.com/shubhambanekar/LatSOFAudio)。它们参考设备为不同代际 cAVS 平台，本机需要实际移植，尚未安装，也没有可用的本机 SOF 驱动。不要把其他机型的 DMA/DSP 参数直接套到本机。
