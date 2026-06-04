# adai-trading-os

这是一个用于交易课程整理、交易系统提炼、行为复盘的 AI 知识工程项目。

目标：

* 对交易课程进行结构化整理
* 自动提炼交易术语
* 自动提炼交易规则
* 长期构建个人交易系统
* 降低信息噪音
* 提高交易系统一致性

目录说明：

* temp/
  临时文本目录，用于存放从云盘下载的课程文本。

* raw/
  原始主题文本目录。
  每个文件（.txt 或 .md）代表一天或一个主题的转录内容。
  原始内容永久保留，不允许删除。

* cleaned/
  清洗后的文本。
  仅做最低限度清洗：删除末尾SC念词名单，其余内容（闲聊、个人色彩、口语表达）全部保留。
  不改变原文结构。

* glossary/
  交易术语库（按课程归档）。
  自动提取术语并生成定义。
  每个文件对应一堂课，用于存档和增量回溯。

* glossary/current/
  融合后的统一术语库（唯一有效定义来源）。
  由 auto glossary + manual 人工修正融合而成。
  定期从 glossary/*.glossary.md + manual/glossary/*.md 生成。
  所有 rules 和 system 以 glossary/current/ 为准。

* rules/
  交易规则库。
  从课程中提炼明确规则。
  每批处理完成后，必须基于 glossary/current/ 执行校准（calibrate_rules 流程），确保术语一致性。

* system/
  最终交易系统。
  用于长期收敛后的核心系统。
  每季度收敛一次：去重、升级、剔除短期观点。
  历史版本归档在 system/archive/。

* manual/
  人工修正记录目录。
  
  * manual/glossary/
    人工修正的术语记录。
    当自动提取的术语有误时，在此创建修正记录文件。
    
  * manual/rules/
    人工修正的规则记录。
    
  * manual/system/
    人工修正的系统记录。

* temp/_chunks/
  禁止在 temp 下创建拆分/中间文件目录。
  如处理过程中产生，流程结束后自动清理。

* review/
  用户交易复盘。

工作原则：

1. 永远不删除 raw/ 原始数据
2. 优先提炼明确规则
3. 优先风险控制
4. 不做荐股
5. 不主观发挥
6. 不过度扩展系统复杂度
7. 保持系统简单、明确、可执行
8. 处理流程结束后，自动清理临时文件和残留，不留垃圾

文本处理原则：

* 仅做最低限度修剪：删除末尾SC念词名单、明显的设备调试空行
* 保留闲聊、个人色彩、口语表达
* 保留原文结构
* 保留交易逻辑
* 保留风险相关内容
* 保留案例
* 保留失败案例

术语提取原则：

* 自动发现交易术语
* 自动归类
* 自动补充定义
* 自动更新已有术语

规则提炼原则：

* 将经验表达转换为规则表达
* 尽量结构化
* 不保留模糊情绪表达
* 不创造原文不存在的规则

触发点：

项目有两个主动触发点，对应三种流程模式。

一、raw/ 新增文件 → 新课程处理流程

当 raw/ 目录新增原始课程文件时，执行 prompts/process_all_courses.md 流程：

1. Step 1：生成 cleaned
2. Step 2：提取 glossary（与旧 glossary 增量合并）
3. Step 3：提炼 rules
4. Step 4：更新 system
5. **Step 4.5：融合 glossary**（执行 prompts/fuse_glossary.md —— 将新术语与 manual 修正融合，重新生成 glossary/current/）
6. **Step 4.6：校准 rules**（执行 prompts/calibrate_rules.md —— 基于 glossary/current/ 校准所有 rules）
7. Step 5：创建 processed 标记
8. Step 6：清理

二、manual/glossary/ 新增文件 → 术语修正后重校准

当 manual/glossary/ 下新增人工修正记录时：

1. 执行 prompts/fuse_glossary.md —— 重新融合，更新 glossary/current/
2. 执行 prompts/calibrate_rules.md —— 基于新定义校准所有 rules
3. 如果涉及 system 已有规则，更新 system

三、批量全流程（少用）

从 temp/ 原始文稿到 system 的完整批处理。按日期顺序处理 raw/ 中所有未标记 .done 的文件。

详见 prompts/process_all_courses.md。

处理前检查：

* 检查 manual/glossary/ 下是否有修正记录
* 如有，先加载修正记录，确保输出使用正确术语

最终目标：

形成一个长期稳定、可执行、可复盘的个人交易系统。

季度收敛：

每季度执行一次 system 收敛：
* 去重：同一条规则只保留一条
* 升级：后期课程修正前期的，用新版本
* 剔除：短期市场观点不留
* 归档：收敛前的完整版本保存到 system/archive/
