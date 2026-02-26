# API 配置

## Agent 状态

| Agent | 状态 | 说明 |
|-------|------|------|
| Codex | ✅ VS Code 插件 | 使用 VS Code 中的 Codex 插件 |
| Claude Code | ⏳ 额度重置 | 12点后可用 |
| Gemini | ✅ 已配置 | 使用 .env 中的 Google-api-key |

## 工具状态

| 工具 | 状态 |
|------|------|
| Git | ✅ 已配置 |
| PowerShell Jobs | ✅ 可用（替代tmux） |

## 测试文件

- `new-project/test_gemini.py` - 已准备好测试

## 使用方法

```powershell
# 创建任务
cd F:\openclaw-workspace\scripts
.\create-agent.ps1 -Task "任务描述" -AgentType "claude-code"

# 监控状态
.\monitor.ps1
```
