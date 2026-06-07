cat > stress_test.sh <<'EOF'
#!/bin/bash
# 带超时的并发压测脚本
if [ $# -ne 1 ];then
    echo "用法: $0 并发数量"
    exit 1
fi

CONCURRENT=$1
TASK="查询linux常用运维命令汇总"
TIMEOUT=10  # 每个进程超时10秒自动结束

echo "开始并发压测，并发数: $CONCURRENT，超时时间: ${TIMEOUT}s"
echo "=============================="

pids=()
for ((i=1; i<=$CONCURRENT; i++))
do
    (timeout $TIMEOUT openclaw crestodian --message "$TASK") &
    pids+=($!)
    echo "已拉起第 $i 个进程，PID: ${pids[-1]}"
done

# 等待所有进程
wait "${pids[@]}" 2>/dev/null

echo "=============================="
echo "压测执行完毕（超时进程已被终止）"
EOF
