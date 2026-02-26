# Telegram 通知脚本
# 用法: .\notify-telegram.ps1 -Message "消息内容" -ChatId "Chat ID"

param(
    [string]$Message,
    [string]$ChatId = "",  # 从环境变量读取
    [string]$ParseMode = "Markdown"
)

$workspace = "F:\openclaw-workspace"

# 加载环境变量
if (Test-Path "$workspace\.env") {
    Get-Content "$workspace\.env" | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }
}

$telegramToken = $env:TELEGRAM_BOT_TOKEN
$defaultChatId = $env:TELEGRAM_CHAT_ID

if (-not $ChatId) {
    $ChatId = $defaultChatId
}

if (-not $telegramToken) {
    Write-Host "[Telegram] 未配置 TELEGRAM_BOT_TOKEN" -ForegroundColor Yellow
    exit 1
}

if (-not $ChatId) {
    Write-Host "[Telegram] 未配置 TELEGRAM_CHAT_ID" -ForegroundColor Yellow
    exit 1
}

$url = "https://api.telegram.org/bot$telegramToken/sendMessage"

$body = @{
    chat_id = $ChatId
    text = $Message
    parse_mode = $ParseMode
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -ContentType "application/json" -Body $body
    Write-Host "[Telegram] 消息已发送" -ForegroundColor Green
} catch {
    Write-Host "[Telegram] 发送失败: $_" -ForegroundColor Red
}
