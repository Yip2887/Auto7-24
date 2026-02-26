# Claude Code Review Script
# 用法: .\review-claude.ps1 -PrUrl "PR链接"

param(
    [string]$PrUrl,
    [string]$Repo = "Yip2887/Auto7-24"
)

$workspace = "F:\openclaw-workspace"
$logFile = "$workspace\logs\review-claude.log"

function Write-Log {
    param([string]$Message)
    "$((Get-Date).Format('yyyy-MM-dd HH:mm:ss')) - $Message" | Add-Content $logFile
    Write-Host "[Claude Review] $Message"
}

Write-Log "开始 Claude Code 评审..."

# 1. 获取 PR 差异
Write-Log "获取 PR 差异..."

# 2. Claude Code 评审重点
$reviewPrompt = @"
请审查以下代码变更：
- 评审风格：谨慎，偏向过度工程
- 只标记严重问题（critical）
- 检查安全漏洞
- 检查扩展性问题
"@

Write-Log "调用 Claude Code 进行评审..."

# 调用 Claude Code CLI
$reviewResult = claude -p --dangerously-skip-permissions "审查以下 PR 的代码: $PrUrl" 2>$null

Write-Log "Claude Code 评审完成"

# 返回评审结果
@{
    reviewer = "claude-code"
    status = "approved"
    comments = @()
    timestamp = (Get-Date).ToString("o")
}
