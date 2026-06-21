# adai-trading-os

**交易课程整理 · 交易系统提炼 · 行为复盘** — AI 知识工程项目

将零散的交易课程转录文本，逐步加工为结构化的术语库、规则库和最终交易系统。

---

## 数据流

```
00-temp/ (原始下载) → 01-raw/ (原始归档，不删除)
         │
         ▼
   02-cleaned/ (最低清洗) 
         │
         ├──→ 03-glossary/ (逐课术语)
         │         │
         │         ▼
         │    03-glossary/current/ (融合术语库 = auto + manual)
         │         │
         ├──→ 04-rules/ (逐课规则) ──→ 校准（基于 current）
         │                              │
         │                              ▼
         └────────────────────── 05-system/ (最终交易系统)
                                             ↑
                                   07-manual/glossary/ (人工修正，最高优先级)
```

## 目录结构

| 目录 | 用途 | 说明 |
|:----|:-----|:------|
| `00-temp/` | 从云盘下载的原始课程文本 | 按日期子目录存放，处理后保留合并 .md |
| `01-raw/` | 原始主题文本，**永久保留** | 每课一个 `.md` 文件，严禁删除 |
| `02-cleaned/` | 最低清洗后文本 | 仅删末尾SC念词名单，保留口语/闲聊/失败案例 |
| `03-glossary/` | 逐课术语提取 | 每课一个 `.glossary.md`，AI 自动提取 |
| `03-glossary/current/` | **融合后的统一术语库** | 唯一有效定义来源，auto + manual 融合生成 |
| `04-rules/` | 逐课规则提炼 | 每课一个 `.rules.md`，基于 glossary/current/ 校准 |
| `05-system/` | 最终交易系统 | 每课增量更新，历史版归档在 archive/ |
| `06-processed/` | 流程标记 | `.done` 文件标记已完成的课程 |
| `07-manual/glossary/` | 人工术语修正记录 | 高优先级，覆盖 AI 提取 |
| `07-manual/rules/` | 人工规则修正（预留） | — |
| `07-manual/system/` | 人工系统修正（预留） | — |
| `08-review/` | 交易复盘（预留） | — |
| `09-scripts/` | 工具脚本 | — |
| `10-prompts/` | 提示词模板 | — |

## 处理流程

| 步骤 | 内容 |
|:----:|:-----|
| Step 1 | 合并 00-temp/ → 01-raw/ |
| Step 2 | 生成 02-cleaned/ |
| Step 3 | 提取 03-glossary/*.glossary.md |
| Step 4 | 提炼 04-rules/*.rules.md |
| Step 5 | 更新 05-system/trading-system.md |

详见 [CLAUDE.md](CLAUDE.md)。

## 核心工作原则

1. **绝不删除 01-raw/** 原始数据
2. 优先提炼明确规则，优先风险控制
3. 不做荐股，不主观发挥，不过度扩展系统复杂度
4. 保持系统简单、明确、可执行
5. 上游变更自动触发下游重建
