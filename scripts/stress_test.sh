cat > scripts/stress_test.sh <<'EOF'
#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ];then
    echo "用法: $0 并发数量"
    exit 1
fi

CONCURRENT=$1
TASK="查询linux常用运维命令汇总"
TIMEOUT=10

echo "开始压测，并发数: $CONCURRENT，超时: ${TIMEOUT}s"
echo "=============================="

pids=()
for ((i=1; i<=$CONCURRENT; i++))
do
    (timeout $TIMEOUT openclaw crestodian --message "$TASK") &
    pids+=($!)
done

wait "${pids[@]}" 2>/dev/null
echo "=============================="
echo "压测执行完毕"
EOF
