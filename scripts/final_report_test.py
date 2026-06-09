import requests
import json
import time

API_KEY = "你的TokenHub_API_Key"
API_URL = "https://api.lkeap.cloud.tencent.com/plan/v3/chat/completions"

headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}

def test_task(task_name, prompt):
    print(f"\n===== 任务：{task_name} =====")
    print(f"输入：{prompt}")
    start = time.time()
    data = {
        "model": "hy3-preview",
        "messages": [{"role": "user", "content": prompt}]
    }
    try:
        resp = requests.post(API_URL, headers=headers, json=data)
        resp.raise_for_status()
        end = time.time()
        res = resp.json()
        reply = res["choices"][0]["message"]["content"]
        usage = res["usage"]
        
        print(f"输出：\n{reply}")
        print(f"耗时：{round(end - start, 2)}s")
        print(f"Token：输入 {usage['prompt_tokens']} / 输出 {usage['completion_tokens']} / 总计 {usage['total_tokens']}")
        print("✅ 任务成功\n")
        return True
    except Exception as e:
        print(f"❌ 失败：{e}\n")
        return False

if __name__ == "__main__":
    print("=== 实训全流程测试（模块3+模块4）===")

    # --- 模块3：插件&Skill 功能验证 ---
    print("\n--- 模块3：插件 & Skill 加载测试 ---")
    test_task("base64-encode 测试", "对字符串 'OpenClaw Test' 进行Base64编码")
    test_task("laosi-crypto-encoder 测试", "对字符串 'test123' 进行MD5加密")
    test_task("cj-url-encoder 测试", "对链接 'https://test.com?name=测试&page=1' 做URL编码")
    test_task("encoding-formats 测试", "列出当前支持的所有编码格式")

    # --- 模块4：基线任务 & Token采集 ---
    print("\n--- 模块4：单用户基线任务 & Token采集 ---")
    test_task("联网搜索任务", "总结 2025 年 Python 3.13 的新特性，用3点说明")
    test_task("代码编码任务", "写一个Python函数，实现URL编码（不用urllib库）")

    print("\n=== 所有测试完成，可直接写进报告 ===")
