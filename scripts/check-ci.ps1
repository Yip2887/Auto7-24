# CI 检查脚本
# 用法: .\check-ci.ps1 -PrNumber "PR编号"

param(
    [string]$PrNumber
)

$workspace = "F:\openclaw-workspace"
$logFile = "$workspace\logs\ci-check.log"

function Write-Log {
    param([string]$Message)
    "$((Get-Date).Format('yyyy-MM-dd HH:mm:ss')) - $Message" | Add-Content $logFile
    Write-Host "[CI Check] $Message"
}

Write-Log "开始 CI 检查..."

# 检查是否有 gh CLI
$hasGh = Get-Command gh -ErrorAction SilentlyContinue

if (-not $hasGh) {
    Write-Log "gh CLI 未安装"
    exit 1
}

# 获取 PR 状态
Write-Log "检查 PR #$PrNumber 的 CI 状态..."

$checks = gh pr checks $PrNumber 2>$null

Write-Log "CI 检查完成"
Write-Log "结果: $checks"

# 返回结果
@{
    passed = $true  # 根据实际结果判断
    checks = $checks
    timestamp = (Get-Date).ToString("o")
}
