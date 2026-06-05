用例 1：同功能多版本插件共存兼容测试
前置：已预装 base64、base64-encode
操作：执行openclaw skills install base64-tool cn-base64-tool安装同系列多版本编码插件，openclaw skills list查看加载状态，openclaw skills info 插件名查看详情。
预期：插件均可下载落地；base64、base64-encode 正常被客户端识别加载，base64-tool 磁盘存在但客户端索引异常无法列出，多版本安装无文件冲突。
用例 2：异构不同品类技能混合安装兼容
操作：openclaw skills install laosi-crypto-encoder encoding-formats批量安装跨类型加密插件，list 核对插件列表。
预期：异构插件拉取安装成功，与已有 base64 系列插件共存无依赖报错，插件正常载入列表。
用例 3：异常 / 依赖缺失插件安装容错测试
操作：openclaw skills install damage-base64-plugin missdep-base64-plugin安装异常插件，观察返回信息 +openclaw logs查日志。
预期：目标插件 ClawHub 不存在，返回资源 404，无法下载安装；无异常报错污染已装好的正常插件，受仓库资源约束该场景无法实测。
用例 4：全量插件批量启停功能测试
操作：依次执行openclaw skills disable all、openclaw skills enable all，每次执行后skills list查看状态变化。
预期：批量启用、禁用指令执行生效，插件状态同步刷新，启停逻辑正常。
用例 5：Chat 交互调用技能验证
操作：openclaw chat进入会话，下发混合编码调用指令。
预期：因缺少 OpenAI API Key 鉴权 401，大模型无法调度技能执行运算，仅能验证插件安装层面兼容性。
新增用例 6：插件版本升级兼容性测试（验证升级后兼容性退化）
操作：对已就绪base64/base64-encode执行强制升级openclaw skills install --force base64 base64-encode，升级后skills list、skills info查看插件状态。
预期：插件升级覆盖安装成功，升级后仍为 ready 就绪状态，无加载失效、配置错乱、功能退化问题；旧版本文件平滑替换无残留冗余垃圾文件。
新增用例 7：反复批量启停 + 重复安装，观测资源泄漏 / 内存异常
操作：循环执行：disable all → enable all连续 5 轮；重复 install --force 重装同一插件 3 次，查看日志openclaw logs，观测进程异常报错、残留临时文件。
预期：多次启停 / 反复重装后插件状态正常，无内存占用异常、无冗余残留目录、无配置文件错乱、不存在资源泄漏。
新增用例 8：多品类海量混合 Skill 共存生态兼容（热门技能混装）
操作：skills search查找日程、笔记、加解密、格式化等多领域热门插件，批量安装apple-notes apple-reminders laosi-crypto-encoder encoding-formats，全品类混合共存。
预期：多生态不同用途插件批量安装互不抢占依赖、无冲突报错，全部正常 ready 就绪，整体生态兼容无互相干扰。
