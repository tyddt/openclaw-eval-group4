cat > cleanup_test.sh <<'EOF'
#!/bin/bash
set -euo pipefail

echo "===== 72h网关长稳测试收尾清理 ====="

# 1. 停止网关进程
if [ -f gateway.pid ]; then
    PID=$(cat gateway.pid)
    if ps -p $PID > /dev/null; then
        echo "正在停止网关进程 (PID: $PID)..."
        kill -9 $PID || true
    fi
    rm -f gateway.pid
fi

# 2. 清理残留的openclaw进程（保险操作）
echo "检查并清理所有残留的openclaw进程..."
pkill -9 openclaw 2>/dev/null || true

# 3. 备份日志（可选，保留测试数据）
echo "备份测试日志到 ./test_logs_$(date +%Y%m%d)/"
mkdir -p ./test_logs_$(date +%Y%m%d)
cp gateway.log ./test_logs_$(date +%Y%m%d)/ 2>/dev/null || true

# 4. 清理临时文件
echo "清理临时测试文件..."
rm -f gateway.log long_stability_check.sh cleanup_test.sh
rm -f agent*.log agent*.pid 2>/dev/null || true

echo "===== 清理完成 ====="
echo "测试日志已备份至 ./test_logs_$(date +%Y%m%d)/ 目录"
EOF
