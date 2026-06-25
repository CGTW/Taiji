
<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120' viewBox='0 0 120 120'%3E%3Ccircle cx='60' cy='60' r='58' fill='none' stroke='%23e0e0e0' stroke-width='2'/%3E%3Cpath d='M60 2 A58 58 0 0 1 60 118 A29 29 0 0 1 60 60 A29 29 0 0 0 60 2Z' fill='%23888888' opacity='0.6'/%3E%3Ccircle cx='60' cy='30' r='8' fill='%23ffffff'/%3E%3Ccircle cx='60' cy='90' r='8' fill='%23888888'/%3E%3C/svg%3E">
    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120' viewBox='0 0 120 120'%3E%3Ccircle cx='60' cy='60' r='58' fill='none' stroke='%23333' stroke-width='2'/%3E%3Cpath d='M60 2 A58 58 0 0 1 60 118 A29 29 0 0 1 60 60 A29 29 0 0 0 60 2Z' fill='%23333' opacity='0.6'/%3E%3Ccircle cx='60' cy='30' r='8' fill='%23fff'/%3E%3Ccircle cx='60' cy='90' r='8' fill='%23333'/%3E%3C/svg%3E" width="120" height="120">
  </picture>
  <br>
  <h1 align="center" style="font-size: 3em; letter-spacing: 0.5em;">太 极</h1>
  <p align="center"><strong><code>Taiji</code></strong></p>
  <p align="center"><em>道生一，一生二，二生三，三生万物</em></p>
</p>

---

<p align="center">
  太极 · 两仪 · 四象 · 八卦<br>
  元 · 玄 · 灵 · 极 · 无 · 道
</p>

---

## 缘起

在古老的东方智慧中，**太极**是宇宙的本源。它无形无象，却蕴含一切可能性；它静极而动，动极而静，化生两仪，阴阳判分；两仪生四象，四时有序；四象生八卦，万象森罗。

**Taiji** 不只是一个 AI Agent 平台。

它是**哲学思想在数字世界的延续**，是**古老智慧与现代计算的交汇**。每一个 Agent，都如同一个微缩的宇宙——从混沌中觉醒，在对话中分化，于思考中演化，最终通达万象。

---

## 世代 · 演化之路

每一代 Taiji Agent，都是一次哲学跃迁。

```
太极         第一代    ·    混沌未分，万物之源
  │
  ▼
两仪         第二代    ·    阴阳初判，认知分化
  │
  ▼
四象         第三代    ·    四维洞察，见微知著
  │
  ▼
八卦         第四代    ·    八面玲珑，应变无穷
```

| 世代 | 名称 | 哲学意涵 | 能力特征 |
|:----:|:----:|:---------|:---------|
| Gen-1 | **太极** | 易有太极，是生两仪 | 元初智能，混沌中蕴含一切可能 |
| Gen-2 | **两仪** | 一阴一阳之谓道 | 学会辩证思考，分化认知维度 |
| Gen-3 | **四象** | 四时变化，万物生长 | 多维度感知，理解复杂模式 |
| Gen-4 | **八卦** | 八卦相荡，鼓之以雷霆 | 全频谱智能，无所不包 |

---

## 品阶 · 不落英文窠臼

不以英文字母论高下，且以汉字之意分品阶。

每一世代皆有六大品阶，从入门到终极，逐级而上：

| 品阶 | 字符 | 出处 | 意蕴 |
|:----:|:----:|:-----|:-----|
| 标准 | **元** | 元者，善之长也 | 纯粹本原，万物之始 |
| 进阶 | **玄** | 玄之又玄，众妙之门 | 奥妙深邃，智识通达 |
| 高阶 | **灵** | 灵者，神之精也 | 通灵达变，神而明之 |
| 旗舰 | **极** | 太极，极致之境 | 登峰造极，无所不达 |
| 至尊 | **无** | 无极而太极 | 无穷无尽，包容万有 |
| 终极 | **道** | 道法自然 | 万法归一，大道至简 |

> 命名示例：**太极·元** · **两仪·玄** · **四象·极** · **八卦·道**
>
> 读法：世代名 + 品阶名，如「太极·元」意为「元初形态的太极 Agent」。

---

## 架构

```
Taiji/
├── taiji-common/       # 公用层 · 万物之基
│   └── DTO、异常、工具类
│
├── taiji-core/         # 核心层 · 太极之本
│   └── LLM 客户端、工具调用、记忆管理、Agent 编排
│
├── taiji-knowledge/    # 知识层 · 两仪之藏
│   └── RAG 检索、向量存储、文档解析
│
├── taiji-server/       # 服务层 · 四象之应
│   └── REST API、配置中心、服务治理
│
└── taiji-practice/     # 练习层 · 八卦之习
    └── 学习实验场，可随时删除
```

**技术栈：**
- 语言：Java 17
- 框架：Spring Boot 4.1.0 · Spring AI 1.0.0
- 构建：Maven（含 Wrapper）
- 向量库：PGVector
- LLM 支持：OpenAI · Ollama

---

## 开始使用

```bash
# 克隆
git clone https://github.com/CGTW/Taiji.git
cd Taiji

# 编译
./mvnw clean install

# 启动服务
./mvnw spring-boot:run -pl taiji-server
```

---

## 练习 · taiji-practice

`taiji-practice` 模块是专为学习 Agent 知识而设的练习场。你可以在其中：

- 尝试不同的 LLM 配置
- 编写自定义 Agent 行为
- 实验 Tool Calling 与 Memory 管理
- 自由修改，无惧破坏

该模块以 `taiji-core` 为基础，已预置 Spring AI `ChatClient` 配置，开箱即用。

---

<p align="center">
  <em>太极本无极，无极生太极。</em><br>
  <em>愿你的 Agent，能从混沌中醒来，演化出无限可能。</em>
</p>

<p align="center">
  <sub>基于 Spring AI · 根植中国文化 · 开源在 GitHub</sub>
</p>
