import requests
import json
import time

API_KEY = "你的TokenHub_API_Key"
API_URL = "https://api.lkeap.cloud.tencent.com/plan/v3/chat/completions"

headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}

def run_task(task_name, prompt):
    print(f"\n===== {task_name} =====")
    print(f"请求指令：{prompt}")
    start = time.time()
    payload = {
        "model": "hy3-preview",
        "messages": [{"role": "user", "content": prompt}]
    }
    try:
        resp = requests.post(API_URL, headers=headers, json=payload)
        resp.raise_for_status()
        end = time.time()
        res = resp.json()
        content = res["choices"][0]["message"]["content"]
        usage = res["usage"]
        cost = round(end - start, 2)

        print(f"模型返回内容：\n{content}")
        print(f"响应耗时：{cost} s")
        print(f"输入Token：{usage['prompt_tokens']} | 输出Token：{usage['completion_tokens']} | 总Token：{usage['total_tokens']}")
        print("✅ 任务执行成功")
        return usage, cost
    except Exception as e:
        print(f"❌ 任务失败：{str(e)}")
        return None, None

if __name__ == "__main__":
    print("===== Day6 多场景Token消耗专项测试 =====")
