### 用例1 同功能多版本插件共存安装兼容性测试
前置条件：ClawHub 存在多款 Base64 同用途不同实现插件：base64、base64-encode、base64-tool、cn-base64-tool
操作步骤
1. 依次执行openclaw skills install base64、openclaw skills install base64-encode、openclaw skills install base64-tool、openclaw skills install cn-base64-tool；
2. 执行openclaw skills list查看已加载插件清单；
3. 执行openclaw skills info 插件名查看插件详情。
预期结果：全部插件均可正常从仓库下载并落地本地目录，磁盘无文件覆盖冲突；base64、base64-encode 客户端正常识别为 Ready 就绪；base64-tool、cn-base64-tool 物理安装成功，客户端索引异常无法通过 info/list 识别，属于客户端展示 bug，安装层兼容合格。

### 用例2 异构多品类技能批量混装生态兼容测试
前置条件：ClawHub 拥有日程提醒、编解码、格式转换多领域插件：apple-notes、apple-reminders、laosi-crypto-encoder、encoding-formats
操作步骤
1. openclaw skills install apple-notes apple-reminders laosi-crypto-encoder encoding-formats批量安装异构插件；//不支持批量安装，只能一个一个安装
2. openclaw skills list核对插件就绪状态。
预期结果：多品类不同依赖的插件批量安装无依赖冲突、无安装报错，全部正常就绪，与已装 Base64 系列插件共存互不干扰。

### 用例3 插件 --force 强制版本升级兼容性测试（防版本退化）
前置条件：base64、base64-encode 已完成初始安装并就绪
操作步骤
1. openclaw skills install --force base64、openclaw skills install --force base64-encode强制覆盖升级；
2. 升级后执行openclaw skills list查看状态。
预期结果：新版本覆盖安装成功，插件仍保持 Ready 就绪，配置不丢失、功能无降级、无兼容性退化。

### 用例4 重复多次强制重装，验证磁盘 / 内存资源泄漏
前置条件：base64-encode 已正常安装
操作步骤
1. 连续 3 次执行openclaw skills install --force base64-encode反复覆盖重装；
2. 查看openclaw logs系统运行日志，检查本地插件目录。
预期结果：多次重装无冗余残留目录、无临时垃圾文件、日志无内存异常报错，不存在磁盘 / 内存资源泄漏。

### 用例5 异常 / 依赖缺失破损插件安装容错测试
前置条件：计划测试损坏插件 damage-base64-plugin、缺依赖插件 missdep-base64-plugin
操作步骤：openclaw skills install damage-base64-plugin missdep-base64-plugin
预期结果：插件资源不存在时返回 404，终止安装，不会污染现有正常插件。
实测备注：ClawHub 无对应插件资源，返回 404 Not Found，受仓库资源限制，本场景无法落地实测。

### 用例6 插件 enable/disable 启停功能兼容性测试
操作步骤：尝试执行openclaw skills disable/enable 插件名
实测备注：当前客户端 CLI 不支持 enable、disable 子命令，本用例无法执行，终止测试。

### 用例7 Chat 交互多技能联动调用验证
操作步骤：openclaw chat进入交互会话，下发多插件组合编码指令
预期结果：大模型正常调度多款 Skill 串联执行运算。
实测备注：环境缺少 OpenAI 有效 API Key，鉴权返回 401，大模型无法启动，技能只能安装就绪，无法实际调用运算，本场景无法实测功能。
