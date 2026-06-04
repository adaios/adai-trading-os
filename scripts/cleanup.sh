#!/bin/bash
# 清理临时文件和残留
# 每次处理流程结束后执行
# macOS shell 版本（替代 cleanup.ps1）

cleaned_dir="$(cd "$(dirname "$0")/../cleaned" && pwd)"
temp_dir="$(cd "$(dirname "$0")/../temp" && pwd)"

# 1. 删除 cleaned/ 中非标准命名的文件
find "$cleaned_dir" -name "part_*" -type f -delete 2>/dev/null

# 2. 删除 temp/_chunks/
rm -rf "$temp_dir/_chunks" 2>/dev/null

# 3. 删除其他临时工作目录
for d in "$temp_dir"/_*; do
  [ -d "$d" ] && rm -rf "$d" 2>/dev/null
done

echo "清理完成"
