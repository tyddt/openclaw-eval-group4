#!/bin/bash

LOG=day18_$(date +%F_%H%M%S).log

echo "===== OpenClaw Day18 Test Log =====" | tee -a $LOG
echo "Start Time: $(date)" | tee -a $LOG
echo "" | tee -a $LOG

echo "===== PID INFO =====" | tee -a $LOG
ps -ef | grep openclaw | grep -v grep | tee -a $LOG
echo "" | tee -a $LOG

echo "===== PORT STATUS =====" | tee -a $LOG
ss -lntp | grep 39066 | tee -a $LOG
echo "" | tee -a $LOG

echo "===== MEMORY =====" | tee -a $LOG
free -m | tee -a $LOG
echo "" | tee -a $LOG

echo "===== CPU SNAPSHOT =====" | tee -a $LOG
top -bn1 | head -20 | tee -a $LOG
echo "" | tee -a $LOG

echo "END SNAPSHOT: $(date)" | tee -a $LOG
echo "Log saved to: $LOG"
