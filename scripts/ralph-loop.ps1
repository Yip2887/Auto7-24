# Ralph Loop V2 - 完整工作流
# 整合所有步骤的自动化循环

param(
    [string]$Task,           # 任务描述
    [string]$AgentType = "codex"  # codex|claude-code|gemini
)

$workspace = "F:\openclaw-workspace"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Ralph Loop V2 - 智能体工作流" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "任务: $Task" -ForegroundColor White
Write-Host "Agent: $AgentType" -ForegroundColor Cyan
Write-Host "时间: $timestamp" -ForegroundColor Gray
Write-Host ""

# ========== Step 1: Zen 调度 ==========
Write-Host "[Step 1/6] Zen 调度..." -ForegroundColor Yellow
$schedulerScript = "$workspace\scripts\zen-scheduler.ps1"
if (Test-Path $schedulerScript) {
    # Zen 分析任务，选择合适的 Agent
    Write-Host "  → Zen 选择: $AgentType" -ForegroundColor Green
} else {
    Write-Host "  ! 调度脚本不存在" -ForegroundColor Red
}

# ========== Step 2: 创建 Agent ==========
Write-Host "[Step 2/6] 创建 Agent..." -ForegroundColor Yellow
$createScript = "$workspace\scripts\create-agent.ps1"
& $createScript -Task $Task -AgentType $AgentType

# ========== Step 3: 循环监控 ==========
Write-Host "[Step 3/6] 启动监控循环..." -ForegroundColor Yellow
Write-Host "  → 每10分钟检查一次" -ForegroundColor Gray

# 模拟监控循环（实际使用时用定时任务）
$monitorScript = "$workspace\scripts\monitor.ps1"

# ========== Step 4: Agent 创建 PR ==========
Write-Host "[Step 4/6] 等待任务完成后创建 PR..." -ForegroundColor Yellow
Write-Host "  → 任务运行中，请等待..." -ForegroundColor Gray
Write-Host "  → 完成后运行: .\create-pr.ps1 -TaskId `"$timestamp`"" -ForegroundColor Cyan

# ========== Step 5: AI 评审 ==========
Write-Host "[Step 5/6] AI 评审..." -ForegroundColor Yellow
Write-Host "  → Codex 评审" -ForegroundColor Gray
Write-Host "  → Claude Code 评审" -ForegroundColor Gray  
Write-Host "  → Gemini 评审" -ForegroundColor Gray
Write-Host "  → 运行: .\review-*.ps1 -PrUrl `"<PR链接>`"" -ForegroundColor Cyan

# ========== Step 6: 人工审核 & 合并 ==========
Write-Host "[Step 6/6] 人工审核..." -ForegroundColor Yellow
Write-Host "  → CI 检查通过后" -ForegroundColor Gray
Write-Host "  → 3个AI评审通过后" -ForegroundColor Gray
Write-Host "  → 运行: .\merge-cleanup.ps1 -Branch `"agent/$AgentType-$timestamp`"" -ForegroundColor Cyan

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  工作流已启动" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "完整流程:" -ForegroundColor White
Write-Host "  1. create-agent.ps1  → 创建任务" -ForegroundColor Gray
Write-Host "  2. monitor.ps1        → 监控状态" -ForegroundColor Gray
Write-Host "  3. create-pr.ps1     → 创建PR" -ForegroundColor Gray
Write-Host "  4. review-*.ps1      → AI评审" -ForegroundColor Gray
Write-Host "  5. check-ci.ps1      → CI检查" -ForegroundColor Gray
Write-Host "  6. merge-cleanup.ps1 → 合并清理" -ForegroundColor Gray
