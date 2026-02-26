# API 配置

## Agent 状态

| Agent | 状态 | 说明 |
|-------|------|------|
| Codex | ✅ VS Code 插件 | 使用 VS Code 中的 Codex 插件 |
| Claude Code | ⚠️ 未安装 | 需要本地安装 |
| Gemini | ✅ 已配置 | 使用 .env 中的 Google-api-key |

## 工具状态

| 工具 | 状态 |
|------|------|
| Git | ✅ 已配置 |
| tmux | ⚠️ 未安装 |
| Claude Code CLI | ⚠️ 未安装 |

## 环境变量

```
MINIMAX_API_KEY=sk-cp-chFr...
MOONSHOT_API_KEY=sk-kimi-EVp...
Google-api-key=AIzaSyBTo7...
```

## 需要安装

```powershell
# 安装 tmux (Windows via scoop)
scoop install tmux

# 安装 Claude Code
npm install -g @anthropic-ai/claude-code
```
