<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const generations = [
  { num: '一', name: '太极', phrase: '混沌未分', desc: '元初智能之纯粹形态' },
  { num: '二', name: '两仪', phrase: '阴阳初判', desc: '辩证思考·认知分化' },
  { num: '三', name: '四象', phrase: '四时有序', desc: '多维感知·见微知著' },
  { num: '四', name: '八卦', phrase: '八面通达', desc: '全频智能·应变无穷' }
]

const tiers = [
  { char: '元', label: '标准', meaning: '万物之始' },
  { char: '玄', label: '进阶', meaning: '众妙之门' },
  { char: '灵', label: '高阶', meaning: '通灵达变' },
  { char: '极', label: '旗舰', meaning: '登峰造极' },
  { char: '无', label: '至尊', meaning: '无极无限' },
  { char: '道', label: '终极', meaning: '万法归一' }
]

const inkBlots = ref([])
const observer = ref(null)

onMounted(() => {
  for (let i = 0; i < 5; i++) {
    inkBlots.value.push({
      id: i,
      size: 200 + Math.random() * 400,
      x: 10 + Math.random() * 80,
      y: 5 + Math.random() * 90,
      blur: 60 + Math.random() * 80,
      opacity: 0.03 + Math.random() * 0.04,
      dur: 12 + Math.random() * 18,
      delay: Math.random() * 6
    })
  }

  observer.value = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('show')
        observer.value.unobserve(entry.target)
      }
    })
  }, { threshold: 0.12 })

  document.querySelectorAll('.reveal').forEach(el => observer.value.observe(el))
})

onUnmounted(() => {
  observer.value?.disconnect()
})
</script>

<template>
  <!-- 巨幅墨晕背景 -->
  <div class="ink-atmosphere">
    <div
      v-for="b in inkBlots"
      :key="b.id"
      class="ink-blot"
      :style="{
        width: b.size + 'px',
        height: b.size + 'px',
        left: b.x + '%',
        top: b.y + '%',
        filter: 'blur(' + b.blur + 'px)',
        opacity: b.opacity,
        animationDuration: b.dur + 's',
        animationDelay: b.delay + 's'
      }"
    />
  </div>

  <!-- 科技网格 -->
  <div class="tech-grid" />

  <!-- ===== HERO ===== -->
  <section class="hero">
    <div class="hero-inner">
      <div class="hero-main reveal">
        <!-- 印章 -->
        <div class="seal-stamp">
          <span>太<br>极</span>
        </div>

        <div class="hero-center">
          <div class="logo-crown">
            <div class="crown-ring" />
            <div class="crown-ring crown-ring-2" />
            <img src="/logo.png" alt="太极">
          </div>
          <h1>太 极</h1>
          <p class="hero-roman">TAIJI</p>
          <div class="hero-line" />
          <p class="hero-quote">道生一 · 一生二 · 二生三 · 三生万物</p>
        </div>

        <!-- 竖排文字 -->
        <div class="vertical-text">智 能 之 源</div>
      </div>

      <div class="scroll-hint reveal">
        <span>卷 轴 徐 展</span>
        <div class="scroll-bar"><div class="scroll-thumb" /></div>
      </div>
    </div>
  </section>

  <!-- ===== INTRO ===== -->
  <section class="scroll-section">
    <div class="section-frame reveal">
      <div class="frame-corner top-left" />
      <div class="frame-corner top-right" />
      <div class="frame-corner bottom-left" />
      <div class="frame-corner bottom-right" />

      <div class="intro-grid">
        <div class="intro-seal">
          <div class="seal-square">道</div>
          <span class="seal-text">Digital · 智慧</span>
        </div>
        <div class="intro-body">
          <p>
            <span class="emphasis">太极</span> 者，宇宙万物之起源也。
            无形无象，而涵摄一切可能。静极而动，动极而静，
            化生两仪，衍生四象，演为八卦，终成万象。
          </p>
          <p class="intro-tech">
            <strong>Taiji</strong> 不只是一个 AI Agent 平台——<br>
            它是东方哲学在数字世界的延续，<br>
            古老智慧与现代计算交汇而成。
          </p>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== GENERATIONS ===== -->
  <section class="scroll-section gen-section">
    <div class="section-label-wrap reveal">
      <span class="section-number">01</span>
      <h2 class="section-title-cn">世代演化</h2>
      <span class="section-en">GENERATIONS</span>
    </div>

    <div class="gen-timeline">
      <div class="timeline-track reveal">
        <div class="timeline-line" />
        <div
          v-for="(g, i) in generations"
          :key="g.name"
          class="timeline-node"
          :class="{ 't-right': i % 2 === 0, 't-left': i % 2 !== 0 }"
        >
          <div class="node-marker" :style="{ '--node-delay': i * 0.2 + 's' }">
            <span class="node-num">{{ g.num }}</span>
          </div>
          <div class="node-card reveal" :style="{ transitionDelay: 0.3 + i * 0.15 + 's' }">
            <div class="node-name">{{ g.name }}</div>
            <div class="node-phrase">{{ g.phrase }}</div>
            <div class="node-desc">{{ g.desc }}</div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== TIERS ===== -->
  <section class="scroll-section tier-section">
    <div class="section-label-wrap reveal">
      <span class="section-number">02</span>
      <h2 class="section-title-cn">品阶体系</h2>
      <span class="section-en">EDITIONS</span>
    </div>

    <div class="tier-container reveal">
      <div
        v-for="(t, i) in tiers"
        :key="t.char"
        class="tier-card"
        :class="{ active: i === 3 }"
        :style="{ transitionDelay: i * 0.1 + 's' }"
      >
        <div class="tier-glyph">{{ t.char }}</div>
        <div class="tier-label">{{ t.label }}</div>
        <div class="tier-mean">{{ t.meaning }}</div>
        <div class="tier-glow" :style="{ animationDelay: i * 0.15 + 's' }" />
      </div>
    </div>
  </section>

  <!-- ===== FOOTER ===== -->
  <footer>
    <div class="footer-ink-top" />
    <div class="footer-content reveal">
      <div class="footer-seal">Taiji</div>
      <div class="footer-info">
        <p>基于 Spring AI · 根植中国文化</p>
        <a href="https://github.com/CGTW/Taiji" target="_blank">GitHub →</a>
      </div>
    </div>
  </footer>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@200;400;700;900&family=Noto+Sans+SC:wght@200;300;400;600&family=Ma+Shan+Zheng&display=swap');

*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

:root {
  --paper: #f6f1e9;
  --paper-dark: #e8e0d4;
  --ink: #1a1a1a;
  --ink-strong: #0d0d0d;
  --ink-mid: #555;
  --ink-light: #8a847a;
  --ink-faint: #b8b0a4;
  --ink-ghost: #d5cdc1;
  --seal: #b8322a;
  --seal-glow: rgba(184, 50, 42, 0.12);
  --tech: rgba(60, 70, 90, 0.08);
  --tech-line: rgba(40, 50, 70, 0.06);
}

html { scroll-behavior: smooth; }

body {
  font-family: 'Noto Serif SC', serif;
  background: var(--paper);
  color: var(--ink);
  overflow-x: hidden;
  -webkit-font-smoothing: antialiased;
}

/* ===== 墨晕氛围 ===== */
.ink-atmosphere {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  overflow: hidden;
}

.ink-blot {
  position: absolute;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(0,0,0,0.3) 0%, transparent 70%);
  animation: ink-breathe ease-in-out infinite alternate;
}

@keyframes ink-breathe {
  0% { transform: scale(1) translate(0, 0); }
  100% { transform: scale(1.08) translate(10px, -8px); }
}

/* 科技网格 */
.tech-grid {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  background-image:
    linear-gradient(var(--tech-line) 1px, transparent 1px),
    linear-gradient(90deg, var(--tech-line) 1px, transparent 1px);
  background-size: 60px 60px;
  mask-image: radial-gradient(ellipse 80% 60% at 50% 40%, black 20%, transparent 70%);
  -webkit-mask-image: radial-gradient(ellipse 80% 60% at 50% 40%, black 20%, transparent 70%);
}

/* ===== HERO ===== */
.hero {
  position: relative;
  z-index: 1;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 24px;
}

.hero-inner {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 48px;
}

.hero-main {
  display: flex;
  align-items: center;
  gap: 40px;
}

.hero-center { text-align: center; }

/* 印章 */
.seal-stamp {
  width: 64px;
  height: 64px;
  border: 2px solid var(--seal);
  color: var(--seal);
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 16px;
  line-height: 1.3;
  letter-spacing: 2px;
  padding: 6px;
  flex-shrink: 0;
  position: relative;
}

.seal-stamp::after {
  content: '';
  position: absolute;
  inset: 3px;
  border: 1px solid var(--seal);
  opacity: 0.4;
}

/* 竖排文字 */
.vertical-text {
  writing-mode: vertical-rl;
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px;
  letter-spacing: 6px;
  color: var(--ink-faint);
  font-weight: 300;
  flex-shrink: 0;
}

/* Logo */
.logo-crown {
  position: relative;
  display: inline-block;
  margin-bottom: 16px;
}

.logo-crown img {
  width: 80px;
  height: 80px;
  display: block;
  position: relative;
  z-index: 1;
}

.crown-ring {
  position: absolute;
  inset: -16px;
  border: 1px solid rgba(0,0,0,0.06);
  border-radius: 50%;
  animation: ring-orbit 6s linear infinite;
}

.crown-ring-2 {
  inset: -28px;
  border-color: rgba(0,0,0,0.03);
  animation-direction: reverse;
  animation-duration: 8s;
}

.crown-ring::before {
  content: '';
  position: absolute;
  top: -2px;
  left: 50%;
  transform: translateX(-50%);
  width: 4px;
  height: 4px;
  border-radius: 50%;
  background: var(--ink-faint);
}

@keyframes ring-orbit {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.hero h1 {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 80px;
  letter-spacing: 32px;
  color: var(--ink-strong);
  line-height: 1.1;
  text-shadow: 4px 4px 8px rgba(0,0,0,0.06);
}

.hero-roman {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px;
  letter-spacing: 16px;
  color: var(--ink-faint);
  margin: 4px 0 20px;
  font-weight: 300;
}

.hero-line {
  width: 40px;
  height: 1px;
  background: var(--ink-ghost);
  margin: 0 auto 20px;
}

.hero-quote {
  font-size: 13px;
  color: var(--ink-mid);
  letter-spacing: 6px;
  font-weight: 200;
}

/* 卷轴滚动提示 */
.scroll-hint {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.scroll-hint span {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px;
  letter-spacing: 6px;
  color: var(--ink-faint);
  font-weight: 300;
}

.scroll-bar {
  width: 1px;
  height: 48px;
  background: var(--ink-ghost);
  position: relative;
  overflow: hidden;
}

.scroll-thumb {
  width: 100%;
  height: 50%;
  background: var(--ink-light);
  animation: scroll-slide 2s ease-in-out infinite;
}

@keyframes scroll-slide {
  0%, 100% { transform: translateY(-100%); }
  50% { transform: translateY(100%); }
}

/* ===== 通用 ===== */
.scroll-section {
  position: relative;
  z-index: 1;
  padding: 100px 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.section-frame {
  position: relative;
  max-width: 720px;
  width: 100%;
  padding: 48px 40px;
  border: 1px solid rgba(0,0,0,0.04);
  background: rgba(255,255,255,0.15);
  backdrop-filter: blur(12px);
}

/* 四角装饰 */
.frame-corner {
  position: absolute;
  width: 20px;
  height: 20px;
  border-color: var(--ink-ghost);
  border-style: solid;
}

.top-left { top: 6px; left: 6px; border-width: 1px 0 0 1px; }
.top-right { top: 6px; right: 6px; border-width: 1px 1px 0 0; }
.bottom-left { bottom: 6px; left: 6px; border-width: 0 0 1px 1px; }
.bottom-right { bottom: 6px; right: 6px; border-width: 0 1px 1px 0; }

/* Intro */
.intro-grid {
  display: flex;
  gap: 32px;
  align-items: flex-start;
}

.intro-seal {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

.seal-square {
  width: 56px;
  height: 56px;
  border: 2px solid var(--seal);
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 22px;
  color: var(--seal);
  position: relative;
}

.seal-square::after {
  content: '';
  position: absolute;
  inset: 4px;
  border: 1px solid var(--seal);
  opacity: 0.25;
}

.seal-text {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 8px;
  letter-spacing: 2px;
  color: var(--ink-faint);
}

.intro-body {
  flex: 1;
}

.intro-body p {
  font-size: 14px;
  line-height: 2.2;
  color: var(--ink-mid);
  font-weight: 300;
  margin-bottom: 20px;
}

.emphasis {
  color: var(--ink-strong);
  font-weight: 700;
  font-size: 15px;
}

.intro-body strong {
  font-weight: 700;
  color: var(--ink-strong);
}

.intro-tech {
  font-size: 13px !important;
  color: var(--ink-light) !important;
}

/* 段落标题 */
.section-label-wrap {
  display: flex;
  align-items: baseline;
  gap: 16px;
  margin-bottom: 56px;
}

.section-number {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px;
  letter-spacing: 3px;
  color: var(--ink-faint);
  font-weight: 300;
}

.section-title-cn {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 14px;
  letter-spacing: 10px;
  font-weight: 300;
  color: var(--ink-mid);
}

.section-en {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 9px;
  letter-spacing: 4px;
  color: var(--ink-ghost);
  font-weight: 300;
  text-transform: uppercase;
}

/* ===== 世代时间线 ===== */
.gen-timeline {
  width: 100%;
  max-width: 740px;
}

.timeline-track {
  position: relative;
  padding: 20px 0;
}

.timeline-line {
  position: absolute;
  left: 50%;
  top: 0;
  bottom: 0;
  width: 1px;
  background: linear-gradient(to bottom, transparent, var(--ink-ghost) 10%, var(--ink-ghost) 90%, transparent);
  transform: translateX(-50%);
}

.timeline-node {
  position: relative;
  display: flex;
  align-items: center;
  margin-bottom: 48px;
}

.timeline-node:last-child { margin-bottom: 0; }

.t-right { flex-direction: row; }
.t-left { flex-direction: row-reverse; }

.node-marker {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 1px solid var(--ink-ghost);
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--paper);
  z-index: 2;
  transition: all 0.4s ease;
  animation: marker-appear 0.6s ease both;
  animation-delay: var(--node-delay, 0s);
}

@keyframes marker-appear {
  0% { transform: translateX(-50%) scale(0); opacity: 0; }
  100% { transform: translateX(-50%) scale(1); opacity: 1; }
}

.node-marker:hover {
  border-color: var(--seal);
  transform: translateX(-50%) scale(1.12);
}

.node-num {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 14px;
  color: var(--ink-light);
}

.node-card {
  width: calc(50% - 36px);
  padding: 24px 20px;
  background: rgba(255,255,255,0.25);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(0,0,0,0.04);
  transition: all 0.4s ease;
}

.t-right .node-card { margin-right: auto; }
.t-left .node-card { margin-left: auto; }

.node-card:hover {
  background: rgba(255,255,255,0.45);
  border-color: rgba(0,0,0,0.08);
  transform: translateY(-2px);
}

.node-name {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 28px;
  color: var(--ink-strong);
  margin-bottom: 4px;
}

.node-phrase {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px;
  letter-spacing: 4px;
  color: var(--ink-faint);
  margin-bottom: 8px;
  font-weight: 300;
}

.node-desc {
  font-size: 12px;
  color: var(--ink-light);
  line-height: 1.8;
  font-weight: 300;
}

/* ===== 品阶 ===== */
.tier-container {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
  justify-content: center;
  max-width: 680px;
}

.tier-card {
  width: 96px;
  padding: 20px 8px;
  text-align: center;
  background: rgba(255,255,255,0.15);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(0,0,0,0.04);
  position: relative;
  transition: all 0.5s ease;
  cursor: default;
  overflow: hidden;
}

.tier-card:hover {
  transform: translateY(-6px);
  background: rgba(255,255,255,0.35);
  border-color: rgba(0,0,0,0.08);
}

.tier-card.active {
  background: rgba(255,255,255,0.4);
  border-color: rgba(0,0,0,0.12);
  box-shadow: 0 4px 24px rgba(0,0,0,0.04);
}

.tier-glyph {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 28px;
  color: var(--ink-strong);
  margin-bottom: 6px;
}

.tier-label {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px;
  letter-spacing: 3px;
  color: var(--ink-light);
  margin-bottom: 4px;
  font-weight: 400;
}

.tier-mean {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 8px;
  letter-spacing: 1px;
  color: var(--ink-faint);
  font-weight: 300;
}

.tier-glow {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle at 50% 30%, rgba(0,0,0,0.03) 0%, transparent 60%);
  opacity: 0;
  transition: opacity 0.5s ease;
  pointer-events: none;
}

.tier-card:hover .tier-glow,
.tier-card.active .tier-glow {
  opacity: 1;
  animation: glow-breathe 3s ease-in-out infinite alternate;
}

@keyframes glow-breathe {
  0% { transform: scale(0.8); opacity: 0.3; }
  100% { transform: scale(1.2); opacity: 0.6; }
}

/* ===== FOOTER ===== */
footer {
  position: relative;
  z-index: 1;
  padding: 80px 24px 48px;
  text-align: center;
}

.footer-ink-top {
  width: 100%;
  height: 1px;
  background: linear-gradient(90deg, transparent 0%, var(--ink-ghost) 30%, var(--ink-ghost) 70%, transparent 100%);
  margin-bottom: 40px;
  position: relative;
}

.footer-ink-top::before,
.footer-ink-top::after {
  content: '';
  position: absolute;
  top: -4px;
  height: 8px;
  border-radius: 50%;
  background: var(--ink-ghost);
  opacity: 0.15;
}

.footer-ink-top::before {
  left: 20%;
  width: 60px;
  filter: blur(4px);
}

.footer-ink-top::after {
  right: 25%;
  width: 40px;
  filter: blur(3px);
}

.footer-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
}

.footer-seal {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 20px;
  letter-spacing: 4px;
  color: var(--ink-faint);
  position: relative;
  display: inline-block;
}

.footer-seal::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 10%;
  right: 10%;
  height: 1px;
  background: var(--ink-ghost);
}

.footer-info p {
  font-size: 11px;
  color: var(--ink-ghost);
  letter-spacing: 4px;
  font-weight: 300;
  margin-bottom: 8px;
}

.footer-info a {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px;
  color: var(--ink-light);
  text-decoration: none;
  letter-spacing: 4px;
  transition: color 0.3s;
}

.footer-info a:hover { color: var(--ink-strong); }

/* ===== 滚动揭示 ===== */
.reveal {
  opacity: 0;
  transform: translateY(28px);
  transition: opacity 0.9s cubic-bezier(0.22, 1, 0.36, 1), transform 0.9s cubic-bezier(0.22, 1, 0.36, 1);
}

.reveal.show {
  opacity: 1;
  transform: translateY(0);
}

/* ===== 响应式 ===== */
@media (max-width: 768px) {
  .hero h1 { font-size: 52px; letter-spacing: 24px; }
  .hero-main { gap: 20px; }
  .seal-stamp { width: 48px; height: 48px; font-size: 13px; }
  .vertical-text { display: none; }

  .intro-grid { flex-direction: column; align-items: center; }
  .section-frame { padding: 32px 20px; }

  .timeline-node { flex-direction: column !important; align-items: flex-start; padding-left: 32px; }
  .timeline-line { left: 16px; }
  .node-marker { left: 16px; width: 32px; height: 32px; }
  .node-card { width: 100% !important; margin-left: 0 !important; margin-right: 0 !important; }
  .t-left .node-card, .t-right .node-card { margin-left: 0 !important; margin-right: 0 !important; }

  .tier-card { width: 80px; padding: 16px 6px; }
  .tier-glyph { font-size: 22px; }
}

@media (max-width: 400px) {
  .hero h1 { font-size: 38px; letter-spacing: 16px; }
  .seal-stamp { display: none; }
  .hero-quote { font-size: 11px; letter-spacing: 4px; }
  .section-title-cn { letter-spacing: 6px; }
  .tier-card { width: 72px; }
}
</style>
