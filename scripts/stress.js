const WebSocket = require('ws');

// 压测配置
const TARGET_URL = 'ws://10.0.0.16:39066';
const CONCURRENT_COUNT = 50;          // 目标并发连接数
const TEST_DURATION = 60 * 1000;      // 压测时间 60s
const SEND_INTERVAL = 100;           // 消息间隔 100ms
const CONNECT_DELAY = 100;           // 每秒创建 10 个连接

// 全局统计
const stats = {
  attemptConnect: 0,
  successConnect: 0,
  failConnect: 0,
  disconnectCount: 0,
  successSend: 0,
  failSend: 0,
  messageReceived: 0,
};

let startTime;
let activeConnections = 0;

// 创建单个连接
function createConnection(id) {
  stats.attemptConnect++;
  const ws = new WebSocket(TARGET_URL);

  let connected = false;

  // 连接成功
  ws.on('open', () => {
    connected = true;
    stats.successConnect++;
    activeConnections++;

    // 定时发送心跳
    const timer = setInterval(() => {
      if (Date.now() - startTime >= TEST_DURATION) {
        clearInterval(timer);
        ws.close(1000, 'test-end');
        return;
      }

      try {
        ws.send(JSON.stringify({ type: 'ping', time: Date.now() }));
        stats.successSend++;
      } catch (e) {
        stats.failSend++;
      }
    }, SEND_INTERVAL);
  });

  // 收到消息
  ws.on('message', () => {
    stats.messageReceived++;
  });

  // 关闭
  ws.on('close', () => {
    if (connected) activeConnections--;
    stats.disconnectCount++;
  });

  // 错误
  ws.on('error', (err) => {
    if (!connected) stats.failConnect++;
  });
}

// 平滑创建并发连接
async function createConnectionsSmoothly() {
  for (let i = 0; i < CONCURRENT_COUNT; i++) {
    createConnection(i);
    await new Promise(r => setTimeout(r, CONNECT_DELAY));
  }
}

// 输出报告
function printReport() {
  const costSeconds = ((Date.now() - startTime) / 1000).toFixed(1);
  const connectRate = stats.attemptConnect ? ((stats.successConnect / stats.attemptConnect) * 100).toFixed(1) : 0;
  const totalSend = stats.successSend + stats.failSend;
  const sendRate = totalSend ? ((stats.successSend / totalSend) * 100).toFixed(1) : 0;
  const qps = (stats.successSend / costSeconds).toFixed(0);

  console.log('\n==================================');
  console.log('           WebSocket 压测报告');
  console.log('==================================');
  console.log('总耗时：', costSeconds, '秒');
  console.log('尝试连接：', stats.attemptConnect);
  console.log('连接成功：', stats.successConnect);
  console.log('连接失败：', stats.failConnect);
  console.log('连接成功率：', connectRate, '%');
  console.log('当前在线连接：', activeConnections);
  console.log('总断开连接：', stats.disconnectCount);
  console.log('----------------------------------');
  console.log('发送成功：', stats.successSend);
  console.log('发送失败：', stats.failSend);
  console.log('发送成功率：', sendRate, '%');
  console.log('----------------------------------');
  console.log('收到消息：', stats.messageReceived);
  console.log('平均 QPS：', qps);
  console.log('==================================\n');
}

// 启动
async function startTest() {
  startTime = Date.now();
  console.log('WebSocket 压测开始...');
  console.log('目标并发：', CONCURRENT_COUNT);
  console.log('压测时长：', TEST_DURATION / 1000, '秒\n');

  await createConnectionsSmoothly();

  // 压测结束输出报告
  setTimeout(() => {
    printReport();
  }, TEST_DURATION);
}

startTest();