# 融合 glossary：auto + manual

任务：

读取 manual/glossary/ 中的人工定义，并与 AI 自动提取的 glossary 融合。

要求：

1. 人工定义优先级最高
2. 不覆盖 manual 内容
3. 将 AI 自动 glossary 与 manual 定义融合
4. 输出到 glossary/current/
5. 保留：

   * AI 自动补充内容
   * 案例
   * 风险
   * 关联术语

6. 如果 manual 与 auto 存在冲突：
   以 manual 为准

7. 保持定义边界清晰
8. 不允许定义漂移

融合依据目录：

glossary/*.glossary.md          — AI 自动提取（11 份课程）
manual/glossary/*.md            — 人工修正记录
