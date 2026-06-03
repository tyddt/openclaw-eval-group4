day1
1. 网关日志采用shell输出重定向落地，程序不支持--log-path参数，放弃程序内置日志配置；
2. 系统监控依赖：htop、dstat、lsof已全量安装，scripts/claw_monitor.sh每2小时自动巡检采集系统资源；

day2-3
1. 模块1-1 网关启停测试 | 机器：10.0.8.10
1.1 初次start失败原因：网关已在运行（PID:2733440，占用端口11948），日志提示端口占用+进程锁超时；
1.2 openclaw gateway stop：执行成功，正常停止systemd托管的openclaw-gateway.service；
1.3 openclaw gateway restart：执行成功，完成服务重启；
测试结论：网关stop、restart功能可用，启停逻辑符合预期。

