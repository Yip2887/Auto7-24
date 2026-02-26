# AI Agent Swarm - 智能体集群

## 项目结构

```
F:\openclaw-workspace\
├── .clawdbot/          # 系统配置和状态
│   └── state.json     # 任务状态跟踪
├── agents/             # 智能体配置
│   ├── zoe/           # 调度者
│   ├── codex/         # 主力和尚
│   ├── claude-code/   # 前端专家
│   └── gemini/        # 设计师
├── scripts/           # 自动化脚本
│   ├── create-agent.ps1
│   ├── monitor.ps1
│   └── review.ps1
└── logs/              # 日志目录
```

## 角色分工

| Agent | 职责 | 特点 |
|-------|------|------|
| Zoe | 调度/监控 | 全局调度，早上扫描Sentry，会议后提取需求 |
| Codex | 主力 | 90%任务，后端/Bug/重构，慢但稳 |
| Claude Code | 前端 | Git操作，速度快 |
| Gemini | 设计 | HTML/CSS规范输出 |

## 工作流程

1. **需求捕获** → Zoe 从会议/Sentry 提取需求
2. **创建Agent** → 自动创建 Git 分支 + tmux 会话
3. **循环监控** → 每10分钟检查状态
4. **AI评审** → 3个AI分别评审
5. **人工合并** → 最终人工审核
