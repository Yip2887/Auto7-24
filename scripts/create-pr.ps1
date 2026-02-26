# Create PR Script - 自动创建 Pull Request
# 用法: .\create-pr.ps1 -TaskId "任务ID"

param(
    [string]$TaskId
)

$workspace = "F:\openclaw-workspace"
$stateFile = "$workspace\.clawdbot\active-tasks.json"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  创建 Pull Request" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 读取任务
if (-not (Test-Path $stateFile)) {
    Write-Host "没有任务记录" -ForegroundColor Red
    exit 1
}

$tasks = Get-Content $stateFile | ConvertFrom-Json
$task = $tasks | Where-Object { $_.id -eq $TaskId }

if (-not $task) {
    Write-Host "未找到任务: $TaskId" -ForegroundColor Red
    exit 1
}

Set-Location $workspace

# 1. 提交更改
Write-Host "[1/4] 提交更改..." -ForegroundColor Yellow
git add -A 2>$null
git commit -m "feat($($task.agent)): $($task.description)" 2>$null

# 2. 推送分支
Write-Host "[2/4] 推送分支..." -ForegroundColor Yellow
git push -u origin $task.branch 2>$null

# 3. 创建 PR
Write-Host "[3/4] 创建 PR..." -ForegroundColor Yellow

# 检查是否有 gh CLI
$hasGh = Get-Command gh -ErrorAction SilentlyContinue

if ($hasGh) {
    $prUrl = gh pr create --title "$($task.agent): $($task.description)" --body "## 任务
$($task.description)

## Agent
$($task.agent)

## 分支
$($task.branch)

## 自动化检查
- [ ] CI 通过
- [ ] Codex 评审
- [ ] Claude Code 评审
- [ ] Gemini 评审
- [ ] 人工审核
" 2>$null
    
    Write-Host "  → PR 已创建: $prUrl" -ForegroundColor Green
    
    # 更新任务状态
    $task.prUrl = $prUrl
    $task.prCreatedAt = (Get-Date).ToString("o")
    $tasks | ConvertTo-Json | Set-Content $stateFile
} else {
    Write-Host "  ! gh CLI 未安装，请手动创建 PR" -ForegroundColor Yellow
    Write-Host "  分支: $($task.branch)"
}

Write-Host "[4/4] 完成!" -ForegroundColor Green
Write-Host ""
Write-Host "PR 链接: $($task.prUrl)" -ForegroundColor Cyan
