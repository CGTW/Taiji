<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const generations = [
  { num: '一', name: '太极', color: '#ddd' },
  { num: '二', name: '两仪', color: '#bbb' },
  { num: '三', name: '四象', color: '#999' },
  { num: '四', name: '八卦', color: '#666' }
]

const tiers = [
  { char: '元', label: '标准' },
  { char: '玄', label: '进阶' },
  { char: '灵', label: '高阶' },
  { char: '极', label: '旗舰' },
  { char: '无', label: '至尊' },
  { char: '道', label: '终极' }
]

const brushStrokes = ref([])
const observer = ref(null)

onMounted(() => {
  for (let i = 0; i < 12; i++) {
    brushStrokes.value.push({
      id: i,
      width: 40 + Math.random() * 200,
      height: 1 + Math.random() * 3,
      left: Math.random() * 100,
      top: Math.random() * 100,
      opacity: 0.02 + Math.random() * 0.05,
      dur: 8 + Math.random() * 12,
      delay: Math.random() * 10
    })
  }

  observer.value = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('show')
        observer.value.unobserve(entry.target)
      }
    })
  }, { threshold: 0.15 })

  document.querySelectorAll('.reveal').forEach(el => observer.value.observe(el))
})

onUnmounted(() => {
  observer.value?.disconnect()
})
</script>

<template>
  <!-- 背景笔触纹理 -->
  <div class="brush-texture">
    <div
      v-for="s in brushStrokes"
      :key="s.id"
      class="brush-stroke"
      :style="{
        width: s.width + 'px',
        height: s.height + 'px',
        left: s.left + '%',
        top: s.top + '%',
        opacity: s.opacity,
        animationDuration: s.dur + 's',
        animationDelay: s.delay + 's'
      }"
    />
  </div>

  <!-- Hero 全屏 -->
  <section class="hero">
    <div class="ink-wash-bg" />
    <div class="hero-content">
      <div class="logo-frame reveal">
        <div class="logo-ring" />
        <img src="/logo.png" alt="太极">
      </div>
      <h1 class="reveal">太 极</h1>
      <p class="hero-sub reveal">TAIJI</p>
      <p class="hero-quote reveal">道生一 · 一生二 · 二生三 · 三生万物</p>
      <div class="scroll-hint reveal">
        <span>向下探索</span>
        <div class="scroll-line" />
      </div>
    </div>
  </section>

  <!-- Intro -->
  <section class="section intro-section">
    <div class="section-inner">
      <p class="intro-text reveal">
        <span class="seal">太极</span> 者，宇宙万物之起源也。
        无形无象，而涵摄一切可能。
        静极而动，动极而静。
      </p>
      <p class="intro-text reveal">
        <strong>Taiji</strong> 非唯 Agent 平台而已——<br>
        乃东方哲思于数字世界之延续，<br>
        古老智慧与现代计算之交汇。
      </p>
    </div>
  </section>

  <!-- 世代 -->
  <section class="section gen-section">
    <div class="brush-divider reveal" />
    <h2 class="section-label reveal">世 代 演 化</h2>

    <div class="gen-flow">
      <div
        v-for="(g, i) in generations"
        :key="g.name"
        class="gen-node reveal"
        :style="{ transitionDelay: i * 0.15 + 's' }"
      >
        <div class="gen-circle" :style="{ borderColor: g.color }">
          <span class="gen-num">{{ g.num }}</span>
          <span class="gen-name">{{ g.name }}</span>
        </div>
        <div v-if="i < generations.length - 1" class="gen-connector" />
      </div>
    </div>

    <div class="gen-descs">
      <p class="reveal">
        太极混沌，两仪分化，四象洞察，八卦通达。
        每一代 Agent，皆是一次哲学跃迁。
      </p>
    </div>
  </section>

  <!-- 品阶 -->
  <section class="section tier-section">
    <div class="brush-divider reveal" />
    <h2 class="section-label reveal">品 阶 体 系</h2>

    <div class="tier-ring reveal">
      <div
        v-for="(t, i) in tiers"
        :key="t.char"
        class="tier-dot"
        :class="{ active: i === 3 }"
        :style="{ transitionDelay: i * 0.08 + 's' }"
      >
        <span class="tier-char">{{ t.char }}</span>
        <span class="tier-label">{{ t.label }}</span>
      </div>
    </div>
  </section>

  <!-- Footer -->
  <footer>
    <div class="brush-divider" />
    <p>基于 Spring AI · 根植中国文化</p>
    <a href="https://github.com/CGTW/Taiji" target="_blank">GitHub →</a>
  </footer>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@300;400;700&family=Noto+Sans+SC:wght@300;400&family=Ma+Shan+Zheng&display=swap');

*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

:root {
  --paper: #f8f5f0;
  --ink: #1a1a1a;
  --ink-light: #666;
  --ink-faint: #c5bfb5;
  --seal: #c23b22;
  --bg-start: #fafaf7;
  --bg-end: #ece6dc;
}

body {
  font-family: 'Noto Serif SC', serif;
  background: var(--paper);
  color: var(--ink);
  overflow-x: hidden;
  -webkit-font-smoothing: antialiased;
}

/* 背景笔触 */
.brush-texture {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  overflow: hidden;
}

.brush-stroke {
  position: absolute;
  background: var(--ink);
  border-radius: 2px;
  animation: brush-drift linear infinite;
}

@keyframes brush-drift {
  0%, 100% { transform: translateX(0) rotate(0deg); opacity: 0.02; }
  50% { transform: translateX(30px) rotate(2deg); opacity: 0.06; }
}

/* Hero 全屏 */
.hero {
  position: relative;
  z-index: 1;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.ink-wash-bg {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse 80% 50% at 50% 30%, rgba(0,0,0,0.03) 0%, transparent 70%),
    radial-gradient(ellipse 60% 40% at 80% 70%, rgba(0,0,0,0.04) 0%, transparent 60%),
    radial-gradient(ellipse 50% 60% at 20% 60%, rgba(0,0,0,0.02) 0%, transparent 50%);
}

.hero-content {
  text-align: center;
  position: relative;
  padding: 40px 24px;
}

.logo-frame {
  position: relative;
  display: inline-block;
  margin-bottom: 20px;
}

.logo-frame img {
  width: 96px;
  height: 96px;
  display: block;
  position: relative;
  z-index: 1;
}

.logo-ring {
  position: absolute;
  inset: -12px;
  border: 1px solid rgba(0,0,0,0.08);
  border-radius: 50%;
  animation: ring-pulse 4s ease-in-out infinite;
}

@keyframes ring-pulse {
  0%, 100% { transform: scale(1); opacity: 0.3; }
  50% { transform: scale(1.06); opacity: 0.1; }
}

.hero h1 {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 72px;
  letter-spacing: 28px;
  color: var(--ink);
  line-height: 1.2;
}

.hero-sub {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 11px;
  letter-spacing: 14px;
  color: var(--ink-faint);
  margin: 6px 0 24px;
}

.hero-quote {
  font-size: 14px;
  color: var(--ink-light);
  letter-spacing: 6px;
}

.scroll-hint {
  margin-top: 64px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.scroll-hint span {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px;
  letter-spacing: 4px;
  color: var(--ink-faint);
}

.scroll-line {
  width: 1px;
  height: 40px;
  background: linear-gradient(to bottom, var(--ink-faint), transparent);
  animation: scroll-pulse 2s ease-in-out infinite;
}

@keyframes scroll-pulse {
  0%, 100% { opacity: 0.4; transform: scaleY(1); }
  50% { opacity: 0.8; transform: scaleY(1.3); }
}

/* 通用段落 */
.section {
  position: relative;
  z-index: 1;
  padding: 80px 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.section-inner {
  max-width: 640px;
  text-align: center;
}

.intro-text {
  font-size: 15px;
  line-height: 2.2;
  color: var(--ink-light);
  margin-bottom: 24px;
  font-weight: 300;
}

.intro-text strong {
  font-weight: 700;
  color: var(--ink);
}

.seal {
  display: inline-block;
  color: var(--seal);
  font-weight: 700;
  font-size: 16px;
  position: relative;
}

.seal::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  right: 0;
  height: 1px;
  background: var(--seal);
  opacity: 0.3;
}

/* 毛笔分隔线 */
.brush-divider {
  width: 80px;
  height: 2px;
  background: var(--ink);
  opacity: 0.12;
  margin-bottom: 24px;
  position: relative;
}

.brush-divider::after {
  content: '';
  position: absolute;
  top: -2px;
  left: -8px;
  right: -8px;
  height: 6px;
  background: linear-gradient(90deg, transparent 0%, rgba(0,0,0,0.04) 20%, rgba(0,0,0,0.08) 50%, rgba(0,0,0,0.04) 80%, transparent 100%);
  border-radius: 3px;
}

.section-label {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 11px;
  letter-spacing: 10px;
  color: var(--ink-faint);
  margin-bottom: 48px;
  font-weight: 400;
}

/* 世代流程 */
.gen-flow {
  display: flex;
  align-items: center;
  gap: 0;
  max-width: 720px;
  width: 100%;
  padding: 0 16px;
  margin-bottom: 36px;
}

.gen-node {
  flex: 1;
  display: flex;
  align-items: center;
}

.gen-circle {
  width: 100%;
  aspect-ratio: 1;
  max-width: 120px;
  border-radius: 50%;
  border: 1.5px solid;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: rgba(255,255,255,0.5);
  transition: all 0.5s ease;
  margin: 0 auto;
  padding: 8px;
}

.gen-circle:hover {
  background: rgba(255,255,255,0.85);
  transform: scale(1.04);
}

.gen-num {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 13px;
  color: var(--ink-faint);
  letter-spacing: 2px;
}

.gen-name {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 26px;
  color: var(--ink);
  line-height: 1.2;
  margin-top: 2px;
}

.gen-connector {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, var(--ink-faint) 0%, transparent 100%);
  opacity: 0.3;
  margin: 0 4px;
}

.gen-descs {
  max-width: 520px;
  text-align: center;
}

.gen-descs p {
  font-size: 13px;
  line-height: 2;
  color: var(--ink-light);
  font-weight: 300;
}

/* 品阶 */
.tier-ring {
  display: flex;
  justify-content: center;
  gap: 16px;
  flex-wrap: wrap;
  max-width: 600px;
}

.tier-dot {
  width: 76px;
  height: 76px;
  border-radius: 50%;
  border: 1px solid rgba(0,0,0,0.08);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: rgba(255,255,255,0.25);
  transition: all 0.4s ease;
  cursor: default;
}

.tier-dot:hover {
  border-color: rgba(0,0,0,0.18);
  background: rgba(255,255,255,0.5);
  transform: scale(1.06);
}

.tier-dot.active {
  border-color: var(--ink);
  background: rgba(255,255,255,0.6);
}

.tier-char {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 22px;
  color: var(--ink);
  line-height: 1;
}

.tier-label {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 9px;
  color: var(--ink-faint);
  letter-spacing: 2px;
  margin-top: 3px;
}

.tier-dot.active .tier-label {
  color: var(--ink-light);
}

/* 底栏 */
footer {
  position: relative;
  z-index: 1;
  text-align: center;
  padding: 40px 24px 60px;
  color: var(--ink-faint);
  font-size: 12px;
  letter-spacing: 3px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

footer a {
  color: var(--ink-light);
  text-decoration: none;
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 11px;
  letter-spacing: 4px;
  transition: color 0.3s;
}

footer a:hover { color: var(--ink); }

footer .brush-divider {
  margin-bottom: 20px;
}

/* 滚动揭示 */
.reveal {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.8s ease, transform 0.8s ease;
}

.reveal.show {
  opacity: 1;
  transform: translateY(0);
}

/* 响应式 */
@media (max-width: 640px) {
  .hero h1 { font-size: 48px; letter-spacing: 20px; }
  .hero-quote { font-size: 12px; letter-spacing: 4px; }
  .gen-flow { flex-wrap: wrap; gap: 12px; }
  .gen-node { flex: 0 0 45%; }
  .gen-connector { display: none; }
  .gen-circle { max-width: 100px; }
  .gen-name { font-size: 22px; }
}

@media (max-width: 400px) {
  .hero h1 { font-size: 36px; letter-spacing: 14px; }
  .tier-dot { width: 64px; height: 64px; }
  .tier-char { font-size: 18px; }
}
</style>
