# Create Agent Script
# 用法: .\create-agent.ps1 -Task "任务描述" -AgentType "codex|claude-code|gemini"

param(
    [string]$Task,
    [string]$AgentType = "codex"
)

$workspace = "F:\openclaw-workspace"
$newProjectPath = "F:\openclaw-workspace\new-project"
$completePath = "F:\openclaw-workspace\complete"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$branchName = "agent/$AgentType-$timestamp"

# 1. 创建 Git 分支
Write-Host "[1/4] 创建 Git 分支: $branchName"
Set-Location $workspace
git checkout -b $branchName 2>$null

# 2. 安装依赖
Write-Host "[2/4] 安装依赖"
# npm install  # 根据项目情况

# 3. 创建 tmux 会话
$sessionName = "agent-$AgentType-$timestamp"
Write-Host "[3/4] 创建 tmux 会话: $sessionName"
tmux new-session -d -s $sessionName 2>$null

# 4. 记录任务
$taskJson = @{
    id = $timestamp
    agent = $AgentType
    description = $Task
    branch = $branchName
    tmuxSession = $sessionName
    status = "running"
    startTime = (Get-Date).ToString("o")
} | ConvertTo-Json

$stateFile = "$workspace\.clawdbot\active-tasks.json"
$tasks = @()
if (Test-Path $stateFile) {
    $tasks = Get-Content $stateFile | ConvertFrom-Json
}
$tasks += $taskJson | ConvertFrom-Json
$tasks | ConvertTo-Json | Set-Content $stateFile

Write-Host "[4/4] 任务已创建: $timestamp"
Write-Host "分支: $branchName"
Write-Host "tmux: $sessionName"
