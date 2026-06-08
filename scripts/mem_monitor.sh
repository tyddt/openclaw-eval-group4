cat > mem_monitor.sh <<'EOF'
#!/bin/bash
LOG_FILE=mem_usage.log
echo "time,used,free,available" > $LOG_FILE
while true
do
    t=$(date +%H:%M:%S)
    mem=$(free | awk '/Mem/{print $3","$4","$7}')
    echo "$t,$mem" >> $LOG_FILE
    sleep 1
done
EOF
chmod +x mem_monitor.sh
