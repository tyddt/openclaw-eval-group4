cat > stress_test_suite.sh <<'EOF'
#!/bin/bash
if [ $# -lt 1 ]; then
    echo "用法: $0 并发数量 [场景类型]"
    exit 1
fi

concurrency=$1
scene=${2:-default}

echo "并发数: $concurrency, 场景: $scene"

case $scene in
    heartbeat)
        echo "执行心跳风暴压测"
        for i in $(seq 1 $concurrency); do
            openclaw crestodian --message "heartbeat" &
        done
        wait
        ;;
    msg)
        echo "执行高频消息压测"
        for i in $(seq 1 $concurrency); do
            openclaw crestodian --message "查询linux常用运维命令汇总" &
        done
        wait
        ;;
    mix)
        echo "执行混合场景压测（心跳+高频消息）"
        half=$((concurrency / 2))
        for i in $(seq 1 $half); do
            openclaw crestodian --message "heartbeat" &
        done
        for i in $(seq 1 $half); do
            openclaw crestodian --message "查询linux常用运维命令汇总" &
        done
        wait
        ;;
    *)
        echo "执行默认并发压测"
        for i in $(seq 1 $concurrency); do
            openclaw crestodian --message "查询linux常用运维命令汇总" &
        done
        wait
        ;;
esac

echo "压测完成"
EOF
chmod +x stress_test_suite.sh
