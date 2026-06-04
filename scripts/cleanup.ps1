# 清理临时文件和残留
# 每次处理流程结束后执行

$cleaned = "D:\Projects\adai-trading-os\cleaned"
$temp = "D:\Projects\adai-trading-os\temp"

# 1. 删除 cleaned/ 中非标准命名的文件
Get-ChildItem $cleaned -Filter "part_*" | Remove-Item -Force -ErrorAction SilentlyContinue

# 2. 删除 temp/_chunks/
Remove-Item "$temp\_chunks" -Recurse -Force -ErrorAction SilentlyContinue

# 3. 删除其他临时工作目录
Get-ChildItem $temp -Directory | Where-Object { $_.Name -match '^_' } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "清理完成"
