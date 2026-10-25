# 构建与校验

## 环境

参考实机构建工具为 Xcode 16.4（16F6），x86_64，macOS Sequoia 15.8.1。完整Xcode与仅Command Line Tools不同。若全局xcode-select仍指向CLT，可只为当前命令指定：

```sh
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
python3 scripts/build_wifi.py
```

脚本只写仓库的 `build/` 和构建所需生成文件，**不安装、不加载、不覆盖EFI**。编译路径映射去掉本地HOME，随后 `strip -S` 删除调试映射；公开打包时还逐节检查，确认删除调试映射没有修改Mach-O代码/数据节，并检查没有新增内核未定义导入。公开产物仍单独标记为未实机启动验证。

`Sources/AirportItlwm` 已是修改后的完整源码，包含固定SDK和所需固件及其许可。`include/FwBinary.cpp` 是生成文件，未提交；原工程的fw_gen目标会重新生成它。不要将patches内的差异再次应用到此源码。

## 音频

```sh
python3 scripts/build_audio.py
```

脚本下载固定AppleALC提交及Lilu1.7.2 DEBUG，验证Lilu归档SHA-256，复制本仓库已发布的ALC245资源和固定MacKernelSDK后编译。脚本未在此次整理时额外下载/重编全部音频依赖；实机使用的音频二进制来自此前Xcode完整编译并已验证的产物。保留输出与原资源的比较记录见AUDIO.md，不要替换成未修改的原版后仍声称包含输出专用修复。

## EFI 模板

```sh
python3 scripts/validate.py
# 补齐自己的身份与AMFIPass，生成本地config.plist后：
python3 scripts/validate.py --ready
```

默认检查承认唯一有意缺失的AMFIPass依赖；ready检查要求所有启用依赖和非空身份字段。它只核对文件/结构，不证明硬件兼容。还需使用对应OpenCore版本的 `ocvalidate`；公开config.sample身份为空，因此不能作为自己的最终启动配置。

## HiDPI辅助代码

本机保存模式代码依赖macOS私有CGS接口，不能承诺跨系统兼容。原型使用系统Ruby及 `NSHighResolutionCapable=true` 的启动器；公开仓库只提供可审查的模式选择源码，不捆绑整个系统Ruby或伪装为独立应用。需要时自行在合适的高分辨率进程上下文运行；普通解释器可能只返回非HiDPI模式。当前实机配置无需该代码常驻。

## 本次发布校验

- 实际执行随仓库提供的Wi-Fi构建脚本成功，得到的公开二进制SHA-256与已打包版本一致。
- 全部脚本Python AST及Ruby语法检查通过；同构建OpenCore ocvalidate检查模板无错误。
- 模板文件依赖检查通过，唯一有意缺失为上文说明的AMFIPass。
- 完整待发布树按已知机器身份和个人路径扫描通过。
- 没有重新替换原机驱动，没有把公开重建版当作已实机测试。

## 可复现性范围

固定源码提交、资源、依赖版本和编译设置用于复现功能修改；没有承诺不同Xcode/SDK产生字节级相同二进制。实机旧构建与公开隐私重建版SHA不同，清单同时列出以免混淆。不要用“构建成功”代替启动、音频、认证、DHCP及长时间稳定测试。

## 独立策略测试

`tests/test_enterprise_policy.cpp` 穷举65536个EtherType与128组握手上报守卫条件；本次使用AddressSanitizer/UndefinedBehaviorSanitizer执行通过。这验证放行规则和触发条件，不替代实际内核与校园网测试。
