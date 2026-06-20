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

项目有两个主动触发点。

### 触发点一：temp/ 新增日期目录 → 完整批处理流程

当 temp/ 下出现新日期目录（如 `2025-08-06/`），触发完整批处理。

检测方式：扫描 temp/ 下所有日期目录，与 `processed/*.done` 及 `temp/.done/` 对比，
无对应 .done 标记的即为新目录。

> 新目录的自动命名：从课程前几百行自动提取主题句，如"今天的主题是XXX" → 生成 `YYYY-MM-DD_主题.md`。

#### 第一阶段：输入

| 步骤 | 内容 | 产出 |
|:----:|:----|:----|
| Step 1 | 扫描 temp/ 新增日期目录 → 合并 .txt 为 raw/ 文件 | `raw/YYYY-MM-DD_主题.md` |

#### 第二阶段：产出（可并行）

| 步骤 | 内容 | 依赖 | 产出 |
|:----:|:----|:----|:----|
| Step 2 | 生成 cleaned（最低限度清洗） | Step 1 | `cleaned/*.cleaned.md` |
| Step 3 | 提取 glossary（增量合并旧术语） | **Step 2** | `glossary/*.glossary.md` |
| Step 4 | 提炼 rules | **Step 2** | `rules/*.rules.md` |

Step 3/4 无依赖关系，**可并行执行**。

#### 审查环节（人工介入）

**⚠️ 必须在 Step 5 之前人工完成：**

Step 3 完成后，审查 AI 新提取的术语是否有误。如需修正：
1. 在 `manual/glossary/` 下创建修正记录文件
2. 参见已有示例（如 `B1.md`、`顶部大风车.md`）
3. 不修改 AI 自动提取的 `glossary/*.glossary.md` 文件
4. 修正记录会在 Step 5 融合时自动覆盖自动定义

#### 第三阶段：校准（串行）

| 步骤 | 内容 | 依赖 | 产出 |
|:----:|:----|:----|:----|
| Step 5 | **融合 glossary**（fuse_glossary） | Step 3 | `glossary/current/glossary.md` |
| Step 6 | **校准 rules**（calibrate_rules） | Step 4 + Step 5 | 更新 `rules/*.rules.md` 术语引用 |
| Step 7 | **更新 system** | Step 6 | `system/trading-system.md` |

⚠️ Step 5 前必须先备份 `glossary/current/glossary.md`（fusion 操作不可逆）。

#### 第四阶段：收尾（可并行）

| 步骤 | 内容 | 产出 |
|:----:|:----|:----|
| Step 8 | 创建 .done 标记 | `processed/*.done` + `temp/.done/*` |
| Step 9 | 清理 | 删除 temp 拆分文件、非标准输出、中间残留 |

---

### 触发点二：manual/glossary/ 新增文件 → 术语修正后重校准

当 manual/glossary/ 下新增人工修正记录时：

1. **Step 5：融合 glossary**（重新融合，以 manual 为准，更新 glossary/current/）
2. **Step 6：校准 rules**（基于新 current 校准所有 rules）
3. **Step 7：更新 system**（涉及 system 已有规则时才走）

### 处理前检查

* 检查 manual/glossary/ 下是否有修正记录
* 如有，先加载修正记录，确保输出使用正确术语

### 处理顺序

必须按照文件日期顺序处理。课程体系具有演化过程，后期内容可能修正前期规则。

Step 1 扫描新增目录时需按日期排序，先处理旧日期再处理新日期。

### 执行优化

可考虑通过 `Workflow` 工具编排全流程，减少阶段间的人工等待：

```
阶段1: Step 1 (合并+命名)  →  Step 2 (cleaned)  →  Step 3 + Step 4 (并行)
                                                       │
                                                       ▼
                         阶段2: Step 5 → Step 6 → Step 7
                                                       │
                                                       ▼
                         阶段3: Step 8 + Step 9 (并行)
```

（Workflow 编排将在后续迭代中完善。）

最终目标：

形成一个长期稳定、可执行、可复盘的个人交易系统。

季度收敛：

每季度执行一次 system 收敛：
* 去重：同一条规则只保留一条
* 升级：后期课程修正前期的，用新版本
* 剔除：短期市场观点不留
* 归档：收敛前的完整版本保存到 system/archive/
