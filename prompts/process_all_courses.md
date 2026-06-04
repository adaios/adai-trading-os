# 批量处理交易课程

任务：

请扫描 raw/ 目录中的所有文件（.txt 和 .md）。

处理规则：

1. 检查 processed/ 是否存在对应 .done 文件

例如：

raw/
2025-04-23_大富翁导论.md

对应：

processed/
2025-04-23_大富翁导论.done

如果存在：
跳过。

如果不存在：
继续处理。

---

## 预处理：加载修正记录

在开始处理之前：

1. 检查 manual/glossary/ 目录中是否有术语修正记录
2. 如有修正，在生成 glossary 和 rules 时使用修正后的正确表述

---

## Step 1：生成 cleaned 文件

输出到：

cleaned/

要求：

* 仅做最低限度修剪：删除末尾SC念词名单、明显的设备调试空行
* 保留闲聊、个人色彩、口语表达
* 保留原文结构
* 保留：
  * 交易逻辑
  * 风险控制
  * 案例
  * 图形描述
  * 情绪周期
  * 市场环境
  * 失败案例

命名：

2025-04-23_大富翁导论.cleaned.md

---

# Step 2：提取 glossary

输出到：

glossary/

要求：

* 自动发现交易术语
* 如果术语已存在：
  增量更新
* 不覆盖人工定义

**⚠️ 必须执行增量检查：**

在创建新 glossary 文件之前，先 grep 搜索旧 glossary 目录中是否已有相同术语名：

```
grep "^## " glossary/*.glossary.md | grep "术语名"
```

如果发现已有术语名与本课内容重叠：
1. **必须**在新 glossary 文件中标注 `增量更新（日期 课程名）` 追加新内容
2. **同时**在旧 glossary 文件中**追加**增量更新内容，标注来源日期
3. 增量内容放在原定义的末尾，用 `- **增量更新（YYYY-MM-DD 课程名）**：` 格式隔开

示例：
```
## B1 (买点1)
- **定义**：...
- **常见误区**：...
- **增量更新（2025-05-31 端午特训营）**：
  - 主力已减仓的标的短期不要做B1
  - B1要与中线思维结合
```

每个术语包括：

* 定义
* 特征
* 市场意义
* 常见误区
* 案例

---

# Step 3：提炼 rules

输出到：

rules/

要求：

* 提炼明确规则
* 将经验表达转换为结构化规则
* 不主观发挥
* 不创造原文不存在逻辑
* 优先风险控制

---

# Step 4：更新 system

要求：

* 将本次课程提炼的长期稳定规则增量追加到 system
* 不做收敛（收敛按季度独立进行）
* system 只保留长期稳定规则，不允许无限膨胀
* 不保存短期观点、不保存模糊情绪

**⚠️ 每处理完一门课必须执行：**

1. 看规则文件中的**每一条规则**
2. 判断：这条规则是否属于**长期稳定、跨周期有效**？
   - ✅ 是 → 追加到 system
   - ❌ 否（短期判断、临时观点、特定事件解读）→ 不追加
3. 追加前检查 system 是否已有相同规则，防止重复
4. 单独事件解读类课程（如突发消息解读）提炼的规则很少甚至为零，这是正常的

增量追加规则举例：
- "龙虎榜上能看到的机构席位是接盘的" → 长期有效 → 追加到 system
- "6月不是赚大钱的时候" → 短期观点 → 不追加
- "跟庄跟的是实际操盘人" → 长期有效 → 追加到 system

季度收敛规则：

* 去重：同一条规则只保留一条
* 升级：后期课程修正前期的，用新版本
* 剔除：短期市场观点不留
* 归档：收敛前的完整版本保存到 system/archive/

---

# Step 4.5：融合 glossary

**⚠️ 新增步骤，用于保持 glossary/current/ 与 manual/glossary/ 一致。**

详见 prompts/fuse_glossary.md。

操作：

1. 读取 manual/glossary/ 下所有修正记录
2. 读取 glossary/*.glossary.md 中本次新增的自动术语
3. 与 glossary/current/glossary.md 融合
4. 以 manual 定义为最高优先级
5. 输出到 glossary/current/glossary.md

---

# Step 4.6：校准 rules

**⚠️ 新增步骤，消除 rules 与 glossary/current/ 之间的语义漂移。**

详见 prompts/calibrate_rules.md。

操作：

1. 以 glossary/current/glossary.md 为唯一术语定义来源
2. 检查 rules/ 下所有文件中的术语用法是否与 current glossary 一致
3. 存在冲突时以 current glossary 为准
4. 删除模糊表达、不可执行规则、重复规则
5. 使用 `[[]]` 标注关联术语

---

# Step 5：创建 processed 标记

例如：

processed/
2025-04-23_大富翁导论.done

文件内容：

processed at: 当前时间

---

# Step 5.5：完整性验证（新增，防止遗漏）

**在 Step 6 清理之前，必须先执行以下验证：**

```
cd /Users/adai/Projects/adai-trading-os

# 验证1：glossary 增量更新检查
echo "=== 检查本次课程术语是否与旧 glossary 重叠 ==="
# 提取本次新 glossary 的术语
grep "^## " glossary/2025-XXXX_*.glossary.md | sed 's/.*## //' > /tmp/new_terms.txt
# 提取旧 glossary 的术语（排除本次文件）
grep "^## " glossary/*.glossary.md | grep -v "2025-XXXX" | sed 's/.*## //' > /tmp/old_terms.txt
# 找出重叠术语
comm -12 /tmp/new_terms.txt /tmp/old_terms.txt
echo "⚠️ 如上方有输出，说明存在重叠术语，必须在旧 glossary 中追加增量更新"

# 验证2：system 规则追加检查
echo ""
echo "=== 检查本次 rules 是否需要追加到 system ==="
echo "逐条判断 rules/2025-XXXX_*.rules.md 中的每一条："
echo "  - 长期有效 → 追加到 system（注意去重）"
echo "  - 短期观点/事件解读 → 跳过"
```

**必须保证：**

1. ✅ glossary 中重叠的术语已做增量更新（新旧文件都要修改）
2. ✅ system 已追加本次的长期稳定规则（至少1条，除非全是短期观点）
3. ✅ 检查通过后，再进入 Step 6

---

# Step 6：清理临时文件

处理完成后必须清理以下残留：

1. 删除 temp/_chunks/ 目录（如果存在）
2. 删除 temp/ 下所有日期子目录（如 temp/2025-04-23/）中的 .txt 拆分文件
3. 删除 cleaned/ 目录中的 part_*_cleaned.md 等非标准命名文件
4. 删除任何处理过程中产生的临时工作目录

清理原则：

* 只保留按标准命名的输出文件（`日期_标题.cleaned.md`）
* temp/ 目录保留合并后的 .md 文件，用于下次参考
* 不保留拆分文件、中间文件、失败重试的残留
* 不提示用户，自动执行

快捷方式：

bash scripts/cleanup.sh

---

重要原则：

1. 永远不删除 raw 原始数据
2. glossary 可以持续演化
3. rules 允许逐步优化
4. system 必须保持极简
5. 优先风险控制
6. 不做荐股
7. 不预测市场
8. 保持规则边界清晰

处理顺序：

必须按照文件日期顺序处理。

原因：

课程体系具有演化过程。
后期内容可能修正前期规则。
