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
    人工修正的术语记录（必需）。按日期命名的 `.md` 文件，有修正写内容，无需修正创建空文件。
    融合 Step 5 前必须审查完毕。
    
  * manual/rules/
    人工规则修正（预留）。当前不设强制审查门槛。
    
  * manual/system/
    人工系统修正（预留）。当前不设强制审查门槛。

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

项目有三个主动触发点，对应三种流程模式。

---

### 触发点一：temp/ 新增日期目录 → 完整批处理

**入口：** 用户下载文稿到 `temp/` 新目录（如 `temp/2025-10-01/`）

**检测方式：** 扫描 temp/ 下所有日期目录，与 `processed/*.done` 对比，无对应 .done 标记的即为新课程。

> 新目录的自动命名：从课程前几百行自动提取主题句，如"今天的主题是XXX" → 生成 `YYYY-MM-DD_主题.md`。

---

### 触发点二：manual/ 下更新 → 重校准

**入口：** 用户在 `manual/` 下新增/修改了文件

| 操作位置 | 执行步骤 |
|:--------|:---------|
| `manual/glossary/*.md` 变更 | Step 5（融合）→ Step 6（校准 rules）→ Step 7（更新 system） |
| `manual/rules/*.md` 变更 | Step 6（校准 rules）→ Step 7（更新 system） |
| `manual/system/*.md` 变更 | Step 7（更新 system） |

---

### 触发点三：季度收敛

**入口：** 用户发起"季度收敛"

**前置条件（全部满足才可执行）：**
1. ✅ `processed/*.done` 与 `raw/*.md` 完全对齐（所有课程都已标记完成）
2. ✅ `manual/glossary/` 下每门课都有对应的 `YYYY-MM-DD_主题.md` 文件（已审查）

> glossary 是 rules 和 system 的定义基础，glossary 审查通过后 rules/system 的校准由流程自动保证。
> rules 和 system 无需单独设审查门槛——季度收敛的修剪过程本身就是对 system 的质量检验。

**执行内容：**
* 去重：同一条规则只保留一条
* 升级：后期课程修正前期的，用新版本
* 剔除：短期市场观点不留
* 归档：收敛前的完整版本保存到 system/archive/

---

## 全流程详述（触发点一用）

### 预处理：加载修正记录

在开始处理之前：
1. 检查 `manual/glossary/` 下是否有与本次课程同名的 `YYYY-MM-DD_主题.md` 文件
2. 如有内容（非空文件），在生成 glossary 和 rules 时使用修正后的正确表述
3. 空 `.md` 文件视为已审查无需修正，正常处理

### 处理顺序

必须按照文件日期顺序处理。课程体系具有演化过程，后期内容可能修正前期规则。
Step 1 扫描新增目录时需按日期排序，先处理旧日期再处理新日期。

---

### 第一阶段：输入

| 步骤 | 内容 | 产出 |
|:----:|:----|:----|
| Step 1 | 扫描 temp/ 新增日期目录 → 合并 .txt 为 raw/ 文件（如无 temp/ 目录，手动放 raw/ 的文件同样处理） | `raw/YYYY-MM-DD_主题.md` |

### 第二阶段：产出（可并行）

| 步骤 | 内容 | 依赖 | 产出 |
|:----:|:----|:----|:----|
| Step 2 | 生成 cleaned（最低限度清洗） | Step 1 | `cleaned/*.cleaned.md` |
| Step 3 | 提取 glossary（增量合并旧术语） | **Step 2** | `glossary/*.glossary.md` |
| Step 4 | 提炼 rules | **Step 2** | `rules/*.rules.md` |

Step 3/4 无依赖关系，**可并行执行**。

**增量验证 + 审查环节（Step 3 → Step 5 之间，两者可并行）：**

Step 3 完成后，同时触发两个独立流程：

**① 自动：增量验证** — 检查 glossary 增量更新是否到位：

```
# 提取本次新 glossary 的术语
grep "^## " glossary/YYYY-MM-DD_主题.glossary.md | sed 's/.*## //' > /tmp/new_terms.txt
# 提取旧 glossary 的术语（排除本次文件）
grep "^## " glossary/*.glossary.md | grep -v "YYYY-MM-DD" | sed 's/.*## //' > /tmp/old_terms.txt
# 找出重叠术语
comm -12 /tmp/new_terms.txt /tmp/old_terms.txt
# 有输出 → 必须在旧 glossary 文件中追加增量更新，否则不允许进入 Step 5
```

**② 人工：审查环节** — 通知用户审查术语：

审查要点：
1. 打开新生成的 `glossary/YYYY-MM-DD_主题.glossary.md`，检查术语定义是否准确
2. 如需修正，在 `manual/glossary/YYYY-MM-DD_主题.md` 中添加修正内容
3. 参考已有记录格式（如 `manual/glossary/2025-04-23_大富翁导论.md` 含多个术语修正）
4. 如审查后认为无需修正，创建空文件 `touch manual/glossary/YYYY-MM-DD_主题.md`
5. 不修改 AI 自动提取的 `glossary/*.glossary.md` 文件
6. 修正记录在 Step 5 融合时自动覆盖自动定义

用户审查完毕后通知我继续，接着跑 Step 5-9。

### 第三阶段：校准（串行）

| 步骤 | 内容 | 依赖 | 产出 |
|:----:|:----|:----|:----|
| Step 5 | **融合 glossary**（fuse_glossary） | Step 3 + ⚠️ 审查标记就绪 | `glossary/current/glossary.md` |
| Step 6 | **校准 rules**（calibrate_rules） | Step 4 + Step 5 + ⚠️ rules 文件完整 | 更新 `rules/*.rules.md` 术语引用 |
| Step 7 | **更新 system** | Step 6 | `system/trading-system.md` |

⚠️ Step 5 前必须先备份 `glossary/current/glossary.md`（fusion 操作不可逆）。
⚠️ Step 5 前必须验证审查标记：本次课程的 `YYYY-MM-DD_主题.md` 必须在 `manual/glossary/` 中存在。
⚠️ Step 6 前必须验证 rules 文件完整性：本次课程的 `*.rules.md` 必须已全部生成。

### 第四阶段：收尾（可并行）

| 步骤 | 内容 | 产出 |
|:----:|:----|:----|
| Step 8 | 创建 .done 标记 | `processed/*.done` |
| Step 9 | 清理 | 删除 temp 拆分文件、非标准输出、中间残留 |

---

### 执行优化

可考虑通过 `Workflow` 工具编排全流程，减少阶段间的人工等待：

```
阶段1: Step 1 → Step 2 → Step 3 + Step 4 (并行)  →  通知用户审查
                                                          │
                                                          ▼
                                                      用户确认后
                                                          │
                                                          ▼
阶段2: Step 5 → Step 6(→rules验证) → Step 7 → Step 8 + Step 9
```

最终目标：

形成一个长期稳定、可执行、可复盘的个人交易系统。

季度收敛：

见上方触发点三。
