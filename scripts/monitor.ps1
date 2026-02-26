# Monitor Script - Ralph Loop V2
# 每10分钟运行一次，监控所有 Agent 状态

$workspace = "F:\openclaw-workspace"
$completePath = "F:\openclaw-workspace\complete"
$stateFile = "$workspace\.clawdbot\active-tasks.json"

# 检查是否有任务
if (-not (Test-Path $stateFile)) {
    Write-Host "没有活动任务"
    exit 0
}

$tasks = Get-Content $stateFile | ConvertFrom-Json

foreach ($task in $tasks) {
    if ($task.status -eq "done") { continue }

    Write-Host "检查任务: $($task.id) - $($task.agent)"

    # 1. 检查 tmux 会话是否存活
    $sessionAlive = tmux has-session -t $task.tmuxSession 2>$null
    if ($sessionAlive -ne 0) {
        Write-Host "  [!] tmux 会话已结束"
        
        # 2. 检查是否有 PR
        if ($task.prNumber) {
            # 3. 检查 CI 状态
            Write-Host "  [*] 检查 CI 状态..."
            # gh pr checks $task.prNumber
            
            # 4. 检查 AI 评审
            Write-Host "  [*] 检查 AI 评审..."
            
            # 5. 如果全部通过，标记完成并移动到 complete
            $ciPassed = $true  # 替换为实际检查
            $reviewsPassed = $true  # 替换为实际检查
            
            if ($ciPassed -and $reviewsPassed) {
                Write-Host "  [✓] 任务完成，移动到 complete"
                $task.status = "done"
                $task.completedTime = (Get-Date).ToString("o")
                # 可以选择移动文件到 complete 目录
            }
        }
        Write-Host "  [*] 会话运行中"
    }
}

Write-Host "监控完成: $(Get-Date)"
