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
