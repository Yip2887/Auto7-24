# Create Agent Script - Windows 版本
# 使用 PowerShell Jobs 替代 tmux

param(
    [string]$Task,
    [string]$AgentType = "codex"
)

$workspace = "F:\openclaw-workspace"
$newProjectPath = "F:\openclaw-workspace\new-project"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$jobName = "agent-$AgentType-$timestamp"
$branchName = "agent/$AgentType-$timestamp"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AI Agent Swarm - 创建智能体" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 创建 Git 分支
Write-Host "[1/5] 创建 Git 分支: $branchName" -ForegroundColor Yellow
Set-Location $workspace
try {
    git checkout -b $branchName 2>$null
    Write-Host "  ✓ 分支已创建" -ForegroundColor Green
} catch {
    Write-Host "  ! 分支已存在或切换失败" -ForegroundColor Yellow
}

# 2. 安装依赖
Write-Host "[2/5] 安装依赖..." -ForegroundColor Yellow
# npm install 或其他依赖安装命令

# 3. 记录任务
Write-Host "[3/5] 记录任务到状态文件..." -ForegroundColor Yellow
$taskJson = @{
    id = $timestamp
    agent = $AgentType
    description = $Task
    branch = $branchName
    jobName = $jobName
    status = "running"
    startTime = (Get-Date).ToString("o")
}

$stateFile = "$workspace\.clawdbot\active-tasks.json"
$tasks = @()
if (Test-Path $stateFile) {
    $tasks = Get-Content $stateFile | ConvertFrom-Json
}
$tasks += $taskJson
$tasks | ConvertTo-Json | Set-Content $stateFile
Write-Host "  ✓ 任务已记录" -ForegroundColor Green

# 4. 启动 Agent
Write-Host "[4/5] 启动 $AgentType Agent..." -ForegroundColor Yellow

switch ($AgentType) {
    "codex" {
        Write-Host "  → 使用 VS Code Codex 插件" -ForegroundColor Cyan
        # 打开 VS Code
        code --folder-uri "$newProjectPath" 2>$null
    }
    "claude-code" {
        Write-Host "  → 启动 Claude Code..." -ForegroundColor Cyan
        # 使用 Claude Code CLI
        claude -p --dangerously-skip-permissions "在 $newProjectPath 目录完成: $Task" 2>$null
    }
    "gemini" {
        Write-Host "  → 使用 Gemini API..." -ForegroundColor Cyan
        # Gemini API 调用
    }
}

Write-Host "  ✓ Agent 已启动" -ForegroundColor Green

# 5. 显示完成信息
Write-Host "[5/5] 完成!" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  任务信息" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ID:       $timestamp"
Write-Host "  类型:     $AgentType"
Write-Host "  任务:     $Task"
Write-Host "  分支:     $branchName"
Write-Host "  Job:      $jobName"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "运行 monitor.ps1 监控状态" -ForegroundColor Gray
