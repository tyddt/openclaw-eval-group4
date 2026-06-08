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
        # 心跳场景：高频轻量请求，模拟保活心跳
        # 示例：发送空/轻量消息，模拟心跳
        for i in $(seq 1 $concurrency); do
            openclaw crestodian --message "heartbeat" &
        done
        wait
        ;;
    msg)
        echo "执行高频消息压测"
        # 高频消息场景：带业务数据的请求
        # 示例：发送带业务内容的消息
        for i in $(seq 1 $concurrency); do
            openclaw crestodian --message "查询linux常用运维命令汇总" &
        done
        wait
        ;;
    mix)
        echo "执行混合场景压测（心跳+高频消息）"
        # 混合场景：一半心跳，一半业务消息
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
        # 默认场景：和原来的逻辑保持一致
        for i in $(seq 1 $concurrency); do
            openclaw crestodian --message "查询linux常用运维命令汇总" &
        done
        wait
        ;;
esac

echo "压测完成"
