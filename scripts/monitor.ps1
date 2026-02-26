# Monitor Script - Ralph Loop V2 (Windows版本)
# 每10分钟运行一次，监控所有 Agent 状态

$workspace = "F:\openclaw-workspace"
$stateFile = "$workspace\.clawdbot\active-tasks.json"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AI Agent Swarm - 监控面板" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否有任务
if (-not (Test-Path $stateFile)) {
    Write-Host "没有活动任务" -ForegroundColor Yellow
    exit 0
}

$tasks = Get-Content $stateFile | ConvertFrom-Json

$runningCount = 0
$doneCount = 0

foreach ($task in $tasks) {
    if ($task.status -eq "done") { 
        $doneCount++
        continue 
    }
    
    $runningCount++
    Write-Host "────────────────────────────────────" -ForegroundColor Gray
    Write-Host "任务: $($task.id)" -ForegroundColor White
    Write-Host "  Agent:  $($task.agent)" -ForegroundColor Cyan
    Write-Host "  描述:  $($task.description)" -ForegroundColor Gray
    Write-Host "  分支:  $($task.branch)" -ForegroundColor Gray
    Write-Host "  状态:  $($task.status)" -ForegroundColor Yellow
    Write-Host "  开始:  $($task.startTime)" -ForegroundColor Gray
    
    # 检查 Agent 是否还在运行
    $jobs = Get-Job -Name $task.jobName -ErrorAction SilentlyContinue
    if ($jobs) {
        $jobInfo = Receive-Job -Job $jobs
        if ($jobInfo) {
            Write-Host "  → 运行中，输出: $($jobInfo[-1..-5])" -ForegroundColor Green
        }
    } else {
        Write-Host "  [!] Agent 作业已结束" -ForegroundColor Red
        $task.status = "pending_review"
    }
}

Write-Host ""
Write-Host "────────────────────────────────────" -ForegroundColor Gray
Write-Host "统计: 运行中: $runningCount | 已完成: $doneCount" -ForegroundColor Cyan
Write-Host "时间: $(Get-Date)" -ForegroundColor Gray
Write-Host ""
