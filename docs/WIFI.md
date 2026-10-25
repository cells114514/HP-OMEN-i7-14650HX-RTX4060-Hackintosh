# AirportItlwm：企业网络修复

## 上游与固定基线

- 实际基线：[laobamac/itlwm @738d4c61b5a64433b27c1ab09dba94916ab77d8d](https://github.com/laobamac/itlwm/tree/738d4c61b5a64433b27c1ab09dba94916ab77d8d)，2.4.0 alpha。
- 原项目：[OpenIntelWireless/itlwm](https://github.com/OpenIntelWireless/itlwm)；感谢 OpenIntelWireless 维护者、zxystd 及其 net80211/Intel 驱动贡献者。
- 构建 SDK：[acidanthera/MacKernelSDK @3f750085caa17ec3a7880f11c11bf4f48cd6a164](https://github.com/acidanthera/MacKernelSDK/tree/3f750085caa17ec3a7880f11c11bf4f48cd6a164)。

## 现象与修复

第一阶段：系统 eapolclient 表示发送 Identity Response，驱动却未从 BSD 队列送出。原逻辑等 RSN 授权后才启动输出 worker；企业认证本身又需要先发送 EAPOL，形成等待。`eaptx1` 在企业关联的 first beacon 后启动 worker，并对未授权企业端口仅放行完整 EtherType 0x888e 帧；原 net80211 RSN 封装授权检查未改。失败、离网与停止时有对应清理。

第二阶段：服务器已返回 EAP Success，随后发生密钥交换，驱动进入 link active，但约十秒后 WCL 仍以 `4wayHsTimeout` 离网。增加固定数字诊断后证实：worker 和 gate 都成功，ConnectComplete 负载为 164 字节，系统 JoinManager 正常完成，NetManager 也已进入 WAITING_FOR_IP。因此“没有发送 ConnectComplete”的早期假设被排除。

对本机 Sequoia 网络框架的只读接口分析显示：连接完成与 supplicant 完成是独立上报。事件 76（APPLE80211_M_SUPPLICANT_EVENT）使用 40 字节负载；本机处理函数接受该事件后完成握手等待。事件 20 是旧接口，不能未经验证替代。

`eapnotify1` 只在 **enterprise + RUN + BSS存在 + ni_port_valid + 未授权到授权的首次转换** 后发送零状态成功事件。未授权、失败、停止、down、普通 PSK 和重复 up 都不触发。所有原 MIC、重放检测、密钥安装和受控端口校验保留；不在收到 EAP Success 时提前授权，不禁用系统超时。此处私有 ABI 仅核对过当前 Sequoia 分支，不能推广到其他 macOS 版本。

## 证据与边界

- 原测试服务器返回 EAP Success，之后发生 EAPOL-Key 交换；队列/ring submit 只证明描述符提交，不单独证明空口确认。
- 补报后系统从 WAITING_FOR_CONNECT_COMPLEATE → WAITING_FOR_IP → LINK_UP，正常获得 IPv4。
- 校园网持续十几分钟无中断；日志复核无旧握手超时和系统主动离网。
- 仅替换内置 EFI 的 Wi-Fi 执行文件后，拔掉 USB 启动盘重启，校园网再次成功。
- 128 种守卫组合及 ASan/UBSan 检查通过；正常 RSN input/output/crypto/proto 源码保持不变。
- 未完成跨设备、其他企业认证方式、漫游、睡眠恢复与长期稳定测试，不是通用 AirportItlwm 修复保证。

源码已包含全部修改。`patches/` 中的 diff 是排查演进记录；不要把分阶段 patch 再重复应用到已修改的 `Sources/AirportItlwm`。保留诊断标签用于后续排查，但不发布原始账号、密钥、MAC、证书和认证抓包。
