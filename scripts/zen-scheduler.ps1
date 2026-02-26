# Zen 调度器 - 主动性任务
# 每天定时执行：早上扫描Sentry，会议后提取需求，晚上更新Changelog

param(
    [string]$Mode = "all"  # all|morning|evening|meeting
)

$workspace = "F:\openclaw-workspace"
$logFile = "$workspace\logs\zen-scheduler.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Add-Content $logFile
    Write-Host $Message
}

# 加载环境变量
if (Test-Path "$workspace\.env") {
    Get-Content "$workspace\.env" | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }
}

Write-Log "========================================="
Write-Log "Zen Scheduler 开始执行 - Mode: $Mode"
Write-Log "========================================="

# Morning: 扫描 Sentry 错误
if ($Mode -eq "all" -or $Mode -eq "morning") {
    Write-Log "[早上] 扫描 Sentry 错误..."
    
    $sentryUrl = $env:SENTRY_URL
    $sentryToken = $env:SENTRY_TOKEN
    
    if ($sentryUrl -and $sentryToken) {
        # 调用 Sentry API 获取错误
        Write-Log "  → 连接 Sentry..."
        # 这里可以添加 Sentry API 调用
    } else {
        Write-Log "  ! 未配置 Sentry，跳过"
    }
}

# Meeting: 扫描会议记录（从飞书/Slack等）
if ($Mode -eq "all" -or $Mode -eq "meeting") {
    Write-Log "[会议后] 扫描会议记录..."
    
    # 扫描指定的笔记目录（如 Obsidian）
    $notesPath = "$workspace\..\notes"
    if (Test-Path $notesPath) {
        $recentFiles = Get-ChildItem $notesPath -File -ErrorAction SilentlyContinue | 
            Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-2) }
        
        foreach ($file in $recentFiles) {
            Write-Log "  → 发现新文件: $($file.Name)"
            # 提取任务需求
        }
    }
}

# Evening: 更新 Changelog
if ($Mode -eq "all" -or $Mode -eq "evening") {
    Write-Log "[晚上] 更新 Changelog 和文档..."
    
    Set-Location $workspace
    
    # 获取今天的提交
    $today = Get-Date -Format "yyyy-MM-dd"
    $commits = git log --since="$today 00:00:00" --oneline 2>$null
    
    if ($commits) {
        Write-Log "  → 今天提交: $($commits.Count) 个"
        # 更新 CHANGELOG.md
    } else {
        Write-Log "  → 今天无提交"
    }
}

Write-Log "Zen Scheduler 执行完成"
