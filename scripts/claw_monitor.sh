#!/bin/bash
# 写入采集时间
echo "=====$(date)====" >> /var/log/claw_mon.log
# 采集内存使用
free -h >> /var/log/claw_mon.log
# 采集TOP前15行CPU负载
top -b -n1 | head -15 >> /var/log/claw_mon.log
# 采集全量监听端口
ss -tulpn >> /var/log/claw_mon.log
