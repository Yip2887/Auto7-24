# AI Agent Swarm - 智能体集群

## 项目结构

```
F:\openclaw-workspace\
├── .clawdbot/           # 系统配置和状态
│   └── state.json      # 任务状态跟踪
├── agents/              # 智能体配置
│   ├── zen/           # 调度者 (原 Zoe)
│   ├── codex/         # 主力工程师
│   ├── claude-code/  # 前端专家
│   └── gemini/       # 设计师
├── scripts/           # 自动化脚本
│   ├── ralph-loop.ps1       # 主工作流
│   ├── create-agent.ps1    # 创建智能体
│   ├── monitor.ps1         # 监控状态
│   ├── create-pr.ps1       # 创建 PR
│   ├── review-codex.ps1    # Codex 评审
│   ├── review-claude.ps1  # Claude Code 评审
│   ├── review-gemini.ps1  # Gemini 评审
│   ├── check-ci.ps1       # CI 检查
│   ├── notify-telegram.ps1 # Telegram 通知
│   ├── merge-cleanup.ps1  # 合并清理
│   └── zen-scheduler.ps1  # Zen 定时任务
├── logs/               # 日志目录
├── new-project/        # 进行中的项目
└── complete/          # 已完成的项目
```

## 角色分工

| Agent | 职责 | 特点 |
|-------|------|------|
| Zen | 调度/监控 | 全局调度，早上扫描Sentry，会议后提取需求 |
| Codex | 主力 | 90%任务，后端/Bug/重构，慢但稳 |
| Claude Code | 前端 | Git操作，速度快 |
| Gemini | 设计 | HTML/CSS规范输出 |

## 工作流程

| 步骤 | 脚本 | 说明 |
|------|------|------|
| 1 | ralph-loop.ps1 | 完整工作流入口 |
| 2 | zen-scheduler.ps1 | Zen 主动调度 |
| 3 | create-agent.ps1 | 创建智能体 |
| 4 | monitor.ps1 | 循环监控 |
| 5 | create-pr.ps1 | 创建 PR |
| 6 | review-*.ps1 | 3个AI评审 |
| 7 | check-ci.ps1 | CI 检查 |
| 8 | notify-telegram.ps1 | Telegram 通知 |
| 9 | merge-cleanup.ps1 | 合并清理 |

## 使用方法

### 快速开始
```powershell
cd F:\openclaw-workspace\scripts

# 启动完整工作流
.\ralph-loop.ps1 -Task "修复用户登录Bug" -AgentType "codex"
```

### 单独步骤
```powershell
# 创建智能体
.\create-agent.ps1 -Task "任务描述" -AgentType "codex"

# 监控状态
.\monitor.ps1

# 创建 PR
.\create-pr.ps1 -TaskId "20260226-123456"

# AI 评审
.\review-codex.ps1 -PrUrl "https://github.com/..."
.\review-claude.ps1 -PrUrl "https://github.com/..."
.\review-gemini.ps1 -PrUrl "https://github.com/..."

# CI 检查
.\check-ci.ps1 -PrNumber "341"

# 合并清理
.\merge-cleanup.ps1 -Branch "agent/codex-20260226-123456"
```

## 环境变量

在 `.env` 文件中配置：

```
MINIMAX_API_KEY=sk-cp-...
MOONSHOT_API_KEY=sk-kimi-...
Google-api-key=AIzaSy...
TELEGRAM_BOT_TOKEN=your_token
TELEGRAM_CHAT_ID=your_chat_id
```

## 定时任务

使用 Windows Task Scheduler 或手动运行：

```powershell
# 每10分钟运行监控
.\monitor.ps1

# 每天早上8点运行 Zen 调度
.\zen-scheduler.ps1 -Mode morning

# 每天晚上10点更新 Changelog
.\zen-scheduler.ps1 -Mode evening
```
