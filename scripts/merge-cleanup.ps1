# Merge & Cleanup Script - 合并后清理
# 用法: .\merge-cleanup.ps1 -Branch "分支名"

param(
    [string]$Branch
)

$workspace = "F:\openclaw-workspace"
$stateFile = "$workspace\.clawdbot\active-tasks.json"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  合并分支并清理" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

Set-Location $workspace

# 1. 合并分支
Write-Host "[1/3] 合并分支: $Branch ..." -ForegroundColor Yellow
git checkout master 2>$null
git pull origin master 2>$null
git merge $Branch --no-ff -m "merge: $Branch into master" 2>$null
git push origin master 2>$null

# 2. 删除远程分支
Write-Host "[2/3] 删除远程分支..." -ForegroundColor Yellow
git push origin --delete $Branch 2>$null

# 3. 删除本地分支
Write-Host "[3/3] 删除本地分支..." -ForegroundColor Yellow
git branch -D $Branch 2>$null

# 4. 更新任务状态
if (Test-Path $stateFile) {
    $tasks = Get-Content $stateFile | ConvertFrom-Json
    $tasks = $tasks | Where-Object { $_.branch -ne "refs/heads/$Branch" }
    $tasks | ConvertTo-Json | Set-Content $stateFile
}

# 5. 清理 worktree（如果有）
Write-Host "清理完成!" -ForegroundColor Green

# 发送 Telegram 通知
$notifyScript = "$workspace\scripts\notify-telegram.ps1"
if (Test-Path $notifyScript) {
    & $notifyScript -Message "✅ 分支 $Branch 已合并并清理"
}
