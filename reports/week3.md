day1
1. 网关日志采用shell输出重定向落地，程序不支持--log-path参数，放弃程序内置日志配置；
2. 系统监控依赖：htop、dstat、lsof已全量安装，scripts/claw_monitor.sh每2小时自动巡检采集系统资源；

day2-3
1. 模块1-1 网关启停测试 | 机器：10.0.8.10
1.1 初次start失败原因：网关已在运行（PID:2733440，占用端口11948），日志提示端口占用+进程锁超时；
1.2 openclaw gateway stop：执行成功，正常停止systemd托管的openclaw-gateway.service；
1.3 openclaw gateway restart：执行成功，完成服务重启；
测试结论：网关stop、restart功能可用，启停逻辑符合预期。

2. 模块 1-2 网关配置修改测试 | 机器：10.0.8.10
2.1 初始状态：网关默认监听端口 11948，openclaw gateway start会自动注册 systemd 服务固化端口，直接修改 JSON 配置后重启不生效；
2.2 操作：编辑网关 JSON 配置文件，将 port 字段由 11948 修改为 11949，停止原有进程后使用openclaw gateway run前台启动（规避 systemd 自动固化旧端口）；
2.3 核验：ss 查询，11949 正常 LISTEN 监听，原 11948 端口无进程占用；配置文件无 heartbeat 配置字段，本版本无法通过配置修改心跳参数；
<img width="1618" height="111" alt="image" src="https://github.com/user-attachments/assets/a56f2945-092b-433b-b2c5-a491d3a69d4f" />
测试结论：端口配置修改 + 重启生效功能可用，配置变更逻辑符合预期；当前版本无心跳配置项，心跳不支持配置修改。

3. 模块2 WebSocket双向通信测试
测试环境：网关10.0.8.10（端口11949）、客户端10.0.8.15
3.1 网关端执行openclaw gateway run启动，ufw allow 11949放行端口，ss确认11949监听；
3.2 客户端安装wscat，执行wscat -c ws://10.0.8.10:11949，成功打印Connected，收到网关握手JSON报文，长连接建立；//客户端可以收到报文，但是服务端收不到客户端回复的挑战应答 JSON
3.3 双向交替发送5条自定义测试文本，客户端→网关、网关→客户端循环收发；//这个目前没成功
3.4 观测结果：全程连接无自动断开，每条接收消息与发送原文完全一致，无乱码、无丢包、无消息缺失。//没成功
测试结论：WebSocket长连接稳定性达标，双向消息收发功能正常，模块2测试通过。
