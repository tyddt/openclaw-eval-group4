cat > scripts/light_test_unit.sh <<'EOF'
#!/bin/bash
# 轻量级压测单元脚本
if [ $# -ne 1 ]; then
    echo "Usage: $0 <concurrency>"
    exit 1
fi

CONCURRENT=$1
pkill -9 openclaw 2>/dev/null

openclaw run --concurrency $CONCURRENT --timeout 10 2>&1

pkill -9 openclaw 2>/dev/null
EOF
chmod +x scripts/light_test_unit.sh
