cat > long_stability_check.sh <<'EOF'
#!/bin/bash
set -euo pipefail

echo "===== 72h网关长稳测试巡检：$(date) ====="

echo "网关进程状态："
ps -p $(cat gateway.pid) || echo "网关进程已退出"

echo "端口监听（11949）："
ss -tulpn | grep 11949 || echo "端口未监听"

echo "资源占用："
ps -p $(cat gateway.pid) -o pid,%cpu,%mem,cmd || echo "进程已不存在"

echo "日志错误统计："
grep -i "error\|panic\|fatal" gateway.log | wc -l

echo "巡检完成"
EOF
