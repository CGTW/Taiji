
<p align="center">
  <img src="logo.png" width="120" height="120" alt="Taiji 太极">
  <br>
  <h1 align="center" style="font-size: 3em; letter-spacing: 0.5em;">太 极</h1>
  <p align="center"><strong><code>Taiji</code></strong></p>
  <p align="center"><em>道生一，一生二，二生三，三生万物</em></p>
</p>

---

**Taiji** 是一个基于 **Spring AI 2.0** 的多模块 AI Agent 平台。

它不只是一个框架——它是哲学思想在数字世界的延续，是古老智慧与现代计算的交汇。

---

## 架构

```
Taiji/
├── taiji-common/       🏗 地基 · 公共模块
│   └─ DTO、异常、工具类、Jackson、Validation
│
├── taiji-core/         🧱 核心 · Agent 引擎
│   └─ LLM 客户端、工具调用、记忆管理、Agent 编排
│
├── taiji-knowledge/    🧱 知识库 · RAG 引擎
│   └─ 向量检索 (PGVector)、文档解析、索引管理
│
├── taiji-server/       🏭 服务入口 · 部署单元
│   └─ Spring Boot 启动、REST API、聚合所有模块
│
├── taiji-practice/     🏭 练习场 · 实验沙盒
│   └─ 快速实验 / 测试，可随时删除
│
└── frontend/           🌐 前端 · 独立层
    └─ Vue 3 + Vite，通过 proxy 对接后端
```

**依赖分层（自底向上）：**

| 层 | 模块 | 依赖 |
|:--:|:----:|:----:|
| Layer 0 | `taiji-common` | 无内部依赖 |
| Layer 1 | `taiji-core` · `taiji-knowledge` | → common |
| Layer 2 | `taiji-server` · `taiji-practice` | → core / knowledge |

---

## 技术栈

| 组件 | 选型 |
|------|------|
| 语言 | Java 17 |
| 框架 | Spring Boot 4.1.0 |
| AI | Spring AI 2.0.0 |
| 构建 | Maven + Wrapper |
| 向量库 | PGVector |
| LLM | DeepSeek / OpenAI / Ollama |
| 前端 | Vue 3 + Vite |

---

## 开始使用

### 前置条件

- JDK 17+
- Maven 3.8+（或使用项目内 `mvnw`）
- PostgreSQL + PGVector（知识库模块）
- DeepSeek / OpenAI API Key

### 配置 API Key

设置环境变量（推荐）或在 `application.yml` 中配置：

```bash
# Windows PowerShell
$env:DEEPSEEK_API_KEY="your-api-key"

# Linux / macOS
export DEEPSEEK_API_KEY="your-api-key"
```

### 编译 & 启动

```bash
# 编译全部模块
./mvnw clean install

# 启动服务（taiji-server）
./mvnw spring-boot:run -pl taiji-server

# 或启动练习模块（taiji-practice，可独立运行）
./mvnw spring-boot:run -pl taiji-practice
```

### 启动前端

```bash
cd frontend
npm install
npm run dev
```

前端默认运行在 `http://localhost:3000`，API 请求通过 Vite proxy 转发到后端 `8080` 端口。

---

## 练习 · taiji-practice

`taiji-practice` 是专为学习和实验而设的沙盒模块。你可以：

- 尝试不同的 LLM 配置（DeepSeek / OpenAI / Ollama）
- 编写自定义 Agent 行为
- 实验 Tool Calling 与 Memory 管理
- 自由修改，无惧破坏

该模块基于 `taiji-core`，已预置 Spring AI `ChatClient` 配置，开箱即用。

---

## 命名

世代（大版本）与品阶（版本内发行版）共同构成版本号：

| 世代 | 品阶 | 示例 |
|:----:|:----:|:----:|
| 太极 · 两仪 · 四象 · 八卦 | 元 · 玄 · 灵 · 极 · 无 · 道 | `太极·元` = v1 标准版 |

> 命名即版本号，非功能清单。

---

<p align="center">
  <em>太极本无极，无极生太极。</em><br>
  <em>愿你的 Agent，能从混沌中醒来，演化出无限可能。</em>
</p>

<p align="center">
  <sub>基于 Spring AI · 根植中国文化 · 开源在 GitHub</sub>
</p>
