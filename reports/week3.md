1. 网关日志采用shell输出重定向落地，程序不支持--log-path参数，放弃程序内置日志配置；
2. 系统监控依赖：htop、dstat、lsof已全量安装，scripts/claw_monitor.sh每2小时自动巡检采集系统资源；
