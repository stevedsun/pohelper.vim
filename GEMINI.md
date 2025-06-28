# Neovim Scrum PO Plugin

## 📌 项目目标与插件定位

打造一个面向 **PO 的 Neovim Markdown 文档助手插件**，实现以下核心功能：

- 快速生成 PBI 描述、会议记录、Backlog 文档模板

- 中 → 英翻译与英文润色，统一为 “As ..., I want ..., so that ...” 格式

- 可配置扩展 AI prompt：包括翻译、润色、文法纠错等

- 最小侵入本地系统，复用社区已有工具，不造重复轮子

---

## ⚙️ 技术栈与依赖结构

### 🛠 底层技术栈

1. 基于 **`nvim-lua-plugin-template`** 生成项目骨架

2. 插件核心语言与交互库：
   
   - **Lua**（Neovim 原生支持）
   
   - **`plenary.nvim`**：任务调度、HTTP 调用基础
   
   - **`nui.nvim`**：UI 弹窗，用于 prompt 选择、输入交互

3. AI 交互端：**`nomnivore/ollama.nvim`**，通过 HTTP 与 Ollama 在本地通信 ([github.com](https://github.com/nomnivore/ollama.nvim?utm_source=chatgpt.com "GitHub - nomnivore/ollama.nvim: A plugin for managing and integrating ..."), [blog.gitcode.com](https://blog.gitcode.com/1fdfbecc4214e9177f755e4a8fd17ef5.html?utm_source=chatgpt.com "Avante.nvim 中 Ollama 本地大模型支持的技术演进与实践"))

### 🧩 AI Prompt 配置模块

在 `require("ollama").setup{}` 中定义自定义 prompt，如：

```lua
prompts = {
  PBI_Refine = {
    prompt = [[
      Translate and refine the following PBI into proper English in "As … I want … So that …" format:
      $input
    ]],
    model = "mistral",
    action = "replace",
    extract = "```(.*)```",
  },
  Translate_En = {
    prompt = "Translate the following to fluent English:\n$input",
    model = "mistral",
    action = "replace",
  },
}
```

`nomnivore` 插件内置 `prompt` 方法，可实现选区传入并替换输出 ([blog.csdn.net](https://blog.csdn.net/gitblog_00645/article/details/141839991?utm_source=chatgpt.com "Ollama.nvim 项目教程-CSDN博客"))。

---

## 🚀 核心功能组件与命令设计

### 1. `:NewPBI` 快速创建 PBI 模板

- 使用 `plenary.async` 读取内置 Markdown 模板

- 弹窗输入角色/目标/原因等字段，初始化文档并切换 buffer

### 2. `:PBIRefine` AI 英文格式润色

- 获取当前选区文字

- 调用 `require("ollama").prompt("PBI_Refine")`

- 返回后直接替换选中内容

### 3. `:TranslateEn` 翻译命令

- 类似命令，但调用 `"Translate_En"` prompt

### 4. 会议记录模板 `:NewMeeting`

- 自定义模板，包括参会人员、行动项格式

- 支持 `- [ ] Action: ... @owner` 识别为 TODO

### 5. `:ActionSync` 提取会议行动项至 Backlog

- 使用 regex 扫描 Meeting 文档，收集 `Action:` 内容插入 Backlog 文件

### 6. 搜索与导航集成

- 与 `telescope.nvim` 联动，快速搜索项目内各类模板文档（PBI/Meeting/Backlog）

---

## 🧪 测试、文档与 CI

- 使用 `nvim-lua-plugin-template` 自带的 **Busted 测试框架**写核心功能单测

- 使用 **GitHub Actions** 实现 lint、测试、发布流程

- 文档放在 `README.md`，无需 vimdocs（轻量项目即可省略）

---

## 🔧 初始目录结构示意

```
my-po-plugin/
├── lua/
│   └── pohelper/
│       ├── init.lua            -- 插件入口
│       ├── templates.lua       -- 本地模板内容管理
│       └── ai.lua              -- AI 调用封装
├── plugin/
│   └── pohelper.vim            -- cmd 注册
├── tests/
│   └── ai_spec.lua
├── .github/workflows
│   └── ci.yml
├── Makefile
├── README.md
└── init.lua                    -- example 配置
```

---

## 🛠 核心模块逻辑

### `ai.lua` 示例

```lua
local ollama = require("ollama")
local M = {}

function M.refine_selection(prompt_name)
  local sel = vim.fn.getreg('v')  -- 获取 visual 选区
  local resp = ollama.prompt(prompt_name, { input = sel })
  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, {resp})
end

return M
```

### `templates.lua` 示例

```lua
local templates = {
  pbi = [[
## PBI: {title}
**As a** {role}, **I want** {feature}, **so that** {benefit}

### Acceptance Criteria
- [ ] ...
]],
  meeting = [[
# Meeting: {topic}
**Date:** {date}   **Attendees:** {attendees}

## Agenda
1.
2.

## Notes

## Action Items
- [ ] Action: {item} @
]],
}

function M.get(name)
  return templates[name]
end
```

---

## ✅ 执行步骤建议

1. 使用官方 template 建项目骨架，配置 plugin, Makefile, CI

2. 添加社区依赖：`plenary.nvim`、`nui.nvim`、`nomnivore/ollama.nvim`

3. 实现 `:NewPBI`、`:NewMeeting` 等命令生成文档

4. 集成 AI 功能，设计 prompts，完成 `:PBIRefine` 等命令

5. 编写 Busted 单测并配置 GitHub Actions

6. 使用 `telescope.nvim` 支持快速打开模板文档

---

## 🧭 小结：复用社区，不重复造轮子

- **生成插件骨架** 使用 `nvim-lua-plugin-template`

- **UI /函数支持** 来自 `plenary.nvim` + `nui.nvim`

- **AI 功能** 完全托管 `nomnivore/ollama.nvim` 提供 prompt 扩展与动作

- **文档模板** 自定义维护，适配 PO 日常场景

- **测试发布** 利用 template 自带 CI 与测试环境

