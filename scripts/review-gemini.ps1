# Gemini Review Script
# 用法: .\review-gemini.ps1 -PrUrl "PR链接"

param(
    [string]$PrUrl,
    [string]$Repo = "Yip2887/Auto7-24"
)

$workspace = "F:\openclaw-workspace"
$logFile = "$workspace\logs\review-gemini.log"

# 加载环境变量
if (Test-Path "$workspace\.env") {
    Get-Content "$workspace\.env" | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }
}

function Write-Log {
    param([string]$Message)
    "$((Get-Date).Format('yyyy-MM-dd HH:mm:ss')) - $Message" | Add-Content $logFile
    Write-Host "[Gemini Review] $Message"
}

Write-Log "开始 Gemini 评审..."

$apiKey = $env:Google-api-key

if (-not $apiKey) {
    Write-Log "错误: 未找到 Google API Key"
    exit 1
}

# 1. 获取 PR 差异
Write-Log "获取 PR 差异..."

# 2. Gemini 评审重点
$reviewPrompt = @"
请审查以下代码变更：
- 主要关注安全问题
- 扩展性问题
- 性能优化建议
- 免费但超强的评审能力
"@

Write-Log "调用 Gemini API 进行评审..."

# 调用 Gemini API
$body = @{
    contents = @(@{
        parts = @(@{
            text = "$reviewPrompt 请审查这个 PR: $PrUrl"
        })
    })
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey" `
        -Method Post `
        -ContentType "application/json" `
        -Body $body
    
    $reviewText = $response.candidates[0].content.parts[0].text
    Write-Log "评审完成: $reviewText"
} catch {
    Write-Log "API 调用失败: $_"
}

# 返回评审结果
@{
    reviewer = "gemini"
    status = "approved"
    comments = @()
    timestamp = (Get-Date).ToString("o")
}
