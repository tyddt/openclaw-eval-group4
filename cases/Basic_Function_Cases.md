## 模块1：服务启停 & 配置变更测试
测试环境：网关 10.0.8.10
### 用例1-1 网关启停测试
操作步骤：
1. openclaw gateway start
2. ps -ef|grep openclaw 查看进程
3. cat /var/log/openclaw/gateway.err.log 排查错误日志
4. openclaw gateway stop
5. openclaw gateway restart
预期结果：启动/停止/重启无报错，进程正常拉起，错误日志无异常输出。

### 用例1-2 配置变更生效测试
操作步骤：
1. 修改网关配置：gateway.bind监听端口、心跳间隔配置项
2. openclaw gateway restart
3. ss -tulpn | grep [修改后的端口号] 校验端口监听
预期结果：重启后新端口监听生效、配置参数生效。
