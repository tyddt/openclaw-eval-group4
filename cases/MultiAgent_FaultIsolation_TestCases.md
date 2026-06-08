### 用例 1：多 Agent 并行运行互不干扰
用例 ID：TC-DAY13-001
测试场景：启动多个 Agent 实例，验证并行运行无干扰

前置条件：
1. 系统资源充足（CPU、内存未被占满）
2. openclaw 可执行程序正常可用
3. 无同名 / 同端口冲突进程占用

执行步骤：
1. 启动第一个 Agent 实例（后台运行）：
openclaw crestodian --message "agent-1" > agent1.log 2>&1 &
echo $! > agent1.pid
2. 启动第二个 Agent 实例：
openclaw crestodian --message "agent-2" > agent2.log 2>&1 &
echo $! > agent2.pid
3. 启动第三个 Agent 实例：
openclaw crestodian --message "agent-3" > agent3.log 2>&1 &
echo $! > agent3.pid
4. 检查三个进程状态：
ps -p $(cat agent1.pid) $(cat agent2.pid) $(cat agent3.pid)
5. 查看各实例日志，确认均正常运行，无报错

预期结果：
1. 三个 Agent 实例均成功启动，无启动失败或报错
2. 各实例日志独立生成，均输出完整初始化信息，无资源冲突提示
3. 实例间无互相干扰，可独立执行任务

实际结果：与预期结果一致，测试通过。


### 用例 2：单实例故障隔离性验证
用例 ID：TC-DAY13-002
测试场景：模拟单 Agent 故障，验证无连锁崩溃

前置条件：
1. 三个 Agent 实例已正常运行（同用例 1）
2. 系统稳定，无其他高负载进程

执行步骤：
1. 记录三个 Agent 的初始进程状态：
ps -p $(cat agent1.pid) $(cat agent2.pid) $(cat agent3.pid)
2. 手动终止其中一个 Agent（例如 agent1）：
kill -9 $(cat agent1.pid)
3. 再次检查三个进程状态：
ps -p $(cat agent1.pid) $(cat agent2.pid) $(cat agent3.pid)
4. 查看 agent2、agent3 的日志，确认无异常报错；验证 agent2、agent3 仍可正常处理任务

预期结果：
1. 被终止的 agent1 进程退出，状态为 defunct 或消失
2. agent2、agent3 进程状态保持正常，未受影响
3. agent2、agent3 日志无报错，可继续正常工作
4. 无连锁崩溃、无整体服务宕机现象

实际结果：与预期结果一致，测试通过。


### 用例 3：多 Agent 独立运行与隔离性验证
用例 ID：TC-DAY13-003
测试场景：多 Agent 独立运行，故障实例不影响其他进程

前置条件：
1. 三个 Agent 实例已正常运行
2. 日志输出正常，可独立追踪各实例状态

执行步骤：
对三个 Agent 同时执行任务（并发消息）：
1. 三个终端分别执行
tail -f agent1.log
tail -f agent2.log
tail -f agent3.log
2. 模拟 agent2 故障（例如强制终止）：
kill -9 $(cat agent2.pid)
3. 持续观察 agent1、agent3 的日志与进程状态
向 agent1、agent3 发送新任务，验证仍可正常处理

预期结果：
1. agent2 故障退出，agent1、agent3 进程持续运行
2. agent1、agent3 可独立处理新任务，无延迟 / 报错
3. 无资源争抢导致的异常退出
4. 故障实例未占用系统资源，不影响其他进程

实际结果：与预期结果一致，测试通过。





