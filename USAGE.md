# 使用指南

## 项目位置

| 目录 | 用途 |
|------|------|
| `new-project/` | 进行中的项目 |
| `complete/` | 已完成的项目 |

## 工作流程

### 1. 添加新项目
把项目文件放到 `F:\openclaw-workspace\new-project\` 目录下

### 2. 创建 Agent
```powershell
cd F:\openclaw-workspace\scripts
.\create-agent.ps1 -Task "任务描述" -AgentType "codex"
```

Agent 类型：
- `codex` - 后端/Bug修复（主力）
- `claude-code` - 前端/Git操作
- `gemini` - UI设计

### 3. 监控状态
```powershell
.\monitor.ps1
```
每10分钟自动检查任务状态

### 4. 完成后
- 任务自动标记为 done
- 项目可手动移到 `complete` 目录

## 示例

```powershell
# 创建一个后端任务
.\create-agent.ps1 -Task "修复用户登录Bug" -AgentType "codex"

# 创建一个前端任务
.\create-agent.ps1 -Task "实现登录页面" -AgentType "claude-code"

# 创建一个设计任务
.\create-agent.ps1 -Task "设计首页UI规范" -AgentType "gemini"
```
