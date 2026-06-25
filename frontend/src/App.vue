<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const generations = [
  { num: '一', name: '太极', phrase: '混沌未分 · 万物之源', desc: '元初智能之纯粹形态，混沌中蕴含一切可能', trigram: '☰' },
  { num: '二', name: '两仪', phrase: '阴阳初判 · 天地始分', desc: '辩证思考，认知分化，化一为二', trigram: '☵' },
  { num: '三', name: '四象', phrase: '少阴少阳 · 老阴老阳', desc: '多维感知与理解，见微知著，识变从宜', trigram: '☲' },
  { num: '四', name: '八卦', phrase: '天地雷风 · 水火山泽', desc: '八种智能形态通达无碍，应变无穷', trigram: '☯' }
]

const tiers = [
  { char: '元', label: '标准', meaning: '万物之始', line: '—' },
  { char: '玄', label: '进阶', meaning: '众妙之门', line: '--' },
  { char: '灵', label: '高阶', meaning: '通灵达变', line: '—' },
  { char: '极', label: '旗舰', meaning: '登峰造极', line: '--' },
  { char: '无', label: '至尊', meaning: '无极无限', line: '—' },
  { char: '道', label: '终极', meaning: '万法归一', line: '--' }
]

const inkBlots = ref([])
const techParticles = ref([])
const mousePos = ref({ x: 0, y: 0 })
const mouseInk = ref([])
const observer = ref(null)

onMounted(() => {
  for (let i = 0; i < 5; i++) {
    inkBlots.value.push({
      id: i,
      size: 200 + Math.random() * 500,
      x: 5 + Math.random() * 90,
      y: 5 + Math.random() * 90,
      blur: 50 + Math.random() * 100,
      opacity: 0.025 + Math.random() * 0.035,
      dur: 10 + Math.random() * 20,
      delay: Math.random() * 8
    })
  }

  for (let i = 0; i < 30; i++) {
    techParticles.value.push({
      id: i,
      size: 1 + Math.random() * 3,
      x: Math.random() * 100,
      y: Math.random() * 100,
      dur: 20 + Math.random() * 40,
      delay: Math.random() * 15,
      drift: -20 + Math.random() * 40
    })
  }

  document.addEventListener('mousemove', onMouseMove)

  observer.value = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('show')
        observer.value.unobserve(entry.target)
      }
    })
  }, { threshold: 0.1 })

  document.querySelectorAll('.reveal').forEach(el => observer.value.observe(el))
})

function onMouseMove(e) {
  mousePos.value = { x: e.clientX, y: e.clientY }
  mouseInk.value.push({ x: e.clientX, y: e.clientY, life: 1 })
  if (mouseInk.value.length > 20) mouseInk.value.shift()
  mouseInk.value = mouseInk.value.map(d => ({ ...d, life: d.life - 0.05 })).filter(d => d.life > 0)
}

onUnmounted(() => {
  document.removeEventListener('mousemove', onMouseMove)
  observer.value?.disconnect()
})
</script>

<template>
  <!-- 墨晕 -->
  <div class="ink-atmosphere">
    <div v-for="b in inkBlots" :key="b.id" class="ink-blot" :style="{
      width: b.size + 'px', height: b.size + 'px',
      left: b.x + '%', top: b.y + '%',
      filter: 'blur(' + b.blur + 'px)', opacity: b.opacity,
      animationDuration: b.dur + 's', animationDelay: b.delay + 's'
    }" />
  </div>

  <!-- 科技粒子 -->
  <div class="tech-particles">
    <div v-for="p in techParticles" :key="p.id" class="t-particle" :style="{
      width: p.size + 'px', height: p.size + 'px',
      left: p.x + '%', top: p.y + '%',
      animationDuration: p.dur + 's', animationDelay: p.delay + 's',
      '--drift': p.drift + 'px'
    }" />
  </div>

  <!-- 鼠标墨迹 -->
  <div class="mouse-ink">
    <div v-for="(m, i) in mouseInk" :key="i" class="m-ink-dot" :style="{
      left: m.x + 'px', top: m.y + 'px',
      opacity: m.life * 0.15,
      transform: 'scale(' + (1 - m.life) * 2 + ')'
    }" />
  </div>

  <!-- 科技网格 -->
  <div class="tech-grid" />

  <!-- SVG 装饰墨迹 -->
  <svg class="ink-splash" viewBox="0 0 1200 800" preserveAspectRatio="xMidYMid slice">
    <path d="M200 300 Q400 100 600 250 Q800 400 700 600 Q600 750 400 650 Q200 550 200 300Z" fill="rgba(0,0,0,0.015)" />
    <path d="M900 200 Q1050 150 1100 300 Q1150 500 1000 550 Q850 600 900 400 Q880 300 900 200Z" fill="rgba(0,0,0,0.012)" />
    <path d="M300 600 Q450 500 550 650 Q650 800 500 780 Q300 750 300 600Z" fill="rgba(0,0,0,0.008)" />
  </svg>

  <!-- ===== HERO ===== -->
  <section class="hero">
    <div class="hero-bg-layer" />
    <div class="hero-inner">
      <div class="hero-top reveal">
        <span class="hero-badge">DIGITAL · 智慧</span>
      </div>
      <div class="hero-main reveal">
        <div class="seal-stamp">
          <span>太<br>极</span>
        </div>
        <div class="hero-center">
          <div class="logo-crown">
            <div class="crown-ring" />
            <div class="crown-ring crown-ring-2" />
            <div class="crown-ring crown-ring-3" />
            <img src="/logo.png" alt="太极">
          </div>
          <h1>太 极</h1>
          <p class="hero-roman">TAIJI</p>
          <div class="hero-line" />
          <p class="hero-quote">道生一 · 一生二 · 二生三 · 三生万物</p>
        </div>
        <div class="vertical-text">智 能 之 源</div>
      </div>
      <div class="scroll-hint reveal">
        <div class="scroll-track">
          <div class="scroll-progress" />
        </div>
        <span>卷 轴 徐 展</span>
      </div>
    </div>
  </section>

  <!-- ===== INTRO（反白深色段）===== -->
  <section class="dark-section">
    <div class="dark-bg-ink" />
    <div class="dark-content reveal">
      <div class="dark-frame">
        <div class="dark-corner tl" />
        <div class="dark-corner tr" />
        <div class="dark-corner bl" />
        <div class="dark-corner br" />
        <div class="dark-grid">
          <div class="dark-seal">
            <div class="dark-seal-inner">道</div>
            <span>法 · 自 · 然</span>
          </div>
          <div class="dark-text">
            <p class="dark-line dark-line-1">
              <span class="dark-em">太极</span> 者，宇宙万物之起源也。
            </p>
            <p class="dark-line dark-line-2">
              无形无象，而涵摄一切可能。
            </p>
            <p class="dark-line dark-line-3">
              静极而动，动极而静，
              化生两仪，衍生四象，
              演为八卦，终成万象。
            </p>
            <div class="dark-divider" />
            <p class="dark-tech">
              <strong>Taiji</strong> 非唯 Agent 平台而已——<br>
              乃东方哲思于数字世界之延续，<br>
              古老智慧与现代计算之交汇。
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== GENERATIONS ===== -->
  <section class="scroll-section">
    <div class="section-label-wrap reveal">
      <span class="section-number">01</span>
      <h2 class="section-title-cn">世代演化</h2>
      <span class="section-en">GENERATIONS</span>
    </div>

    <div class="gen-flow">
      <div v-for="(g, i) in generations" :key="g.name" class="gen-card-wrap reveal" :style="{ transitionDelay: i * 0.12 + 's' }">
        <div class="gen-card">
          <div class="gen-trigram">{{ g.trigram }}</div>
          <div class="gen-num">GEN · {{ g.num }}</div>
          <div class="gen-name">{{ g.name }}</div>
          <div class="gen-phrase">{{ g.phrase }}</div>
          <div class="gen-dash" />
          <div class="gen-desc">{{ g.desc }}</div>
        </div>
        <div v-if="i < generations.length - 1" class="gen-arrow">
          <svg width="24" height="24" viewBox="0 0 24 24"><path d="M5 12h14M13 5l7 7-7 7" fill="none" stroke="#c5bfb5" stroke-width="0.5"/></svg>
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

    <div class="tier-universe reveal">
      <svg class="tier-orbit-svg" viewBox="0 0 400 200">
        <ellipse cx="200" cy="100" rx="180" ry="60" fill="none" stroke="rgba(0,0,0,0.04)" stroke-width="0.5" />
        <ellipse cx="200" cy="100" rx="140" ry="40" fill="none" stroke="rgba(0,0,0,0.03)" stroke-width="0.5" />
        <ellipse cx="200" cy="100" rx="100" ry="25" fill="none" stroke="rgba(0,0,0,0.02)" stroke-width="0.5" />
      </svg>
      <div v-for="(t, i) in tiers" :key="t.char" class="tier-orb" :class="{ active: i === 3 }"
        :style="{
          '--angle': (i * 60) + 'deg',
          '--delay': i * 0.08 + 's',
          '--rx': (180 - i * 25) + 'px',
          '--ry': (60 - i * 14) + 'px'
        }">
        <div class="orb-inner">
          <span class="orb-char">{{ t.char }}</span>
          <span class="orb-label">{{ t.label }}</span>
        </div>
        <div class="orb-glow" />
      </div>
    </div>

    <div class="tier-legend reveal">
      <div v-for="t in tiers" :key="t.char" class="legend-item">
        <span class="legend-char">{{ t.char }}</span>
        <span class="legend-meaning">{{ t.meaning }}</span>
      </div>
    </div>
  </section>

  <!-- ===== FOOTER ===== -->
  <footer>
    <div class="footer-wave">
      <svg viewBox="0 0 1200 40" preserveAspectRatio="none">
        <path d="M0 20 Q150 0 300 15 Q450 30 600 10 Q750 0 900 18 Q1050 35 1200 8 L1200 40 L0 40Z" fill="rgba(0,0,0,0.02)" />
        <path d="M0 30 Q200 10 400 25 Q600 40 800 20 Q1000 5 1200 25 L1200 40 L0 40Z" fill="rgba(0,0,0,0.015)" />
      </svg>
    </div>
    <div class="footer-inner reveal">
      <div class="footer-brand">太 极</div>
      <div class="footer-divider" />
      <div class="footer-info">
        <span>基于 Spring AI</span>
        <span class="footer-dot">·</span>
        <span>根植中国文化</span>
      </div>
      <a class="footer-link" href="https://github.com/CGTW/Taiji" target="_blank">GITHUB →</a>
    </div>
  </footer>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@200;400;700;900&family=Noto+Sans+SC:wght@200;300;400;600&family=Ma+Shan+Zheng&family=ZCOOL+XiaoWei&display=swap');

*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

:root {
  --paper: #f4efe6;
  --paper-light: #faf8f4;
  --ink: #1a1a1a;
  --ink-strong: #0a0a0a;
  --ink-mid: #4a4a4a;
  --ink-light: #7a746a;
  --ink-faint: #b5ada0;
  --ink-ghost: #d4cdc0;
  --seal: #b8322a;
  --seal-soft: rgba(184, 50, 42, 0.08);
  --glass: rgba(255,255,255,0.12);
  --glass-border: rgba(0,0,0,0.04);
}

html { scroll-behavior: smooth; }

body {
  font-family: 'Noto Serif SC', serif;
  background: var(--paper);
  color: var(--ink);
  overflow-x: hidden;
  -webkit-font-smoothing: antialiased;
  cursor: crosshair;
}

/* ===== 墨晕 ===== */
.ink-atmosphere {
  position: fixed; inset: 0;
  pointer-events: none; z-index: 0;
  overflow: hidden;
}
.ink-blot {
  position: absolute;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(0,0,0,0.25) 0%, transparent 70%);
  animation: ink-float ease-in-out infinite alternate;
}
@keyframes ink-float {
  0% { transform: scale(1) translate(0, 0); }
  100% { transform: scale(1.12) translate(12px, -10px); }
}

/* ===== 科技粒子 ===== */
.tech-particles {
  position: fixed; inset: 0;
  pointer-events: none; z-index: 0;
  overflow: hidden;
}
.t-particle {
  position: absolute;
  border-radius: 50%;
  background: rgba(60, 70, 90, 0.12);
  animation: particle-drift linear infinite;
}
@keyframes particle-drift {
  0% { transform: translateY(100vh) translateX(0); opacity: 0; }
  10% { opacity: 0.5; }
  90% { opacity: 0.3; }
  100% { transform: translateY(-10vh) translateX(var(--drift, 0px)); opacity: 0; }
}

/* ===== 鼠标墨迹 ===== */
.mouse-ink {
  position: fixed; inset: 0;
  pointer-events: none; z-index: 9999;
}
.m-ink-dot {
  position: absolute;
  width: 20px; height: 8px;
  border-radius: 50%;
  background: rgba(0,0,0,0.06);
  transform-origin: center;
  transition: all 0.05s;
  filter: blur(3px);
}

/* ===== 科技网格 ===== */
.tech-grid {
  position: fixed; inset: 0;
  pointer-events: none; z-index: 0;
  background-image:
    linear-gradient(rgba(40,50,70,0.04) 1px, transparent 1px),
    linear-gradient(90deg, rgba(40,50,70,0.04) 1px, transparent 1px);
  background-size: 64px 64px;
  mask-image: radial-gradient(ellipse 70% 50% at 50% 40%, black 15%, transparent 65%);
  -webkit-mask-image: radial-gradient(ellipse 70% 50% at 50% 40%, black 15%, transparent 65%);
}

/* ===== SVG 墨迹 ===== */
.ink-splash {
  position: fixed; inset: 0;
  width: 100%; height: 100%;
  pointer-events: none; z-index: 0;
}

/* ===== HERO ===== */
.hero {
  position: relative; z-index: 1;
  min-height: 100vh;
  display: flex; align-items: center; justify-content: center;
  padding: 40px 24px;
}

.hero-bg-layer {
  position: absolute; inset: 0;
  background:
    radial-gradient(ellipse 60% 40% at 50% 20%, rgba(0,0,0,0.02) 0%, transparent 60%),
    radial-gradient(ellipse 50% 30% at 80% 70%, rgba(0,0,0,0.015) 0%, transparent 50%);
}

.hero-inner {
  display: flex; flex-direction: column; align-items: center; gap: 40px;
}

.hero-top { margin-bottom: -8px; }
.hero-badge {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 9px; letter-spacing: 8px;
  color: var(--ink-faint); font-weight: 300;
}

.hero-main {
  display: flex; align-items: center; gap: 48px;
}

.seal-stamp {
  width: 64px; height: 64px;
  border: 2px solid var(--seal); color: var(--seal);
  display: flex; align-items: center; justify-content: center;
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 16px; line-height: 1.3; letter-spacing: 2px;
  padding: 6px; flex-shrink: 0;
  position: relative;
}
.seal-stamp::after {
  content: ''; position: absolute; inset: 3px;
  border: 1px solid var(--seal); opacity: 0.35;
}

.vertical-text {
  writing-mode: vertical-rl;
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px; letter-spacing: 8px;
  color: var(--ink-faint); font-weight: 300;
  flex-shrink: 0;
}

.hero-center { text-align: center; }

/* Logo 轨道 */
.logo-crown {
  position: relative; display: inline-block; margin-bottom: 16px;
}
.logo-crown img {
  width: 76px; height: 76px; display: block;
  position: relative; z-index: 1;
}
.crown-ring {
  position: absolute; inset: -14px;
  border: 1px solid rgba(0,0,0,0.05);
  border-radius: 50%;
  animation: ring-spin 8s linear infinite;
}
.crown-ring-2 { inset: -26px; animation-duration: 10s; animation-direction: reverse; }
.crown-ring-3 { inset: -38px; animation-duration: 14s; border-color: rgba(0,0,0,0.025); }
.crown-ring::before {
  content: ''; position: absolute; top: -2px; left: 50%;
  transform: translateX(-50%);
  width: 3px; height: 3px; border-radius: 50%;
  background: var(--ink-faint);
}
@keyframes ring-spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.hero h1 {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 84px; letter-spacing: 36px;
  color: var(--ink-strong); line-height: 1.1;
  text-shadow: 4px 4px 12px rgba(0,0,0,0.05);
}
.hero-roman {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px; letter-spacing: 18px;
  color: var(--ink-faint); margin: 2px 0 18px; font-weight: 300;
}
.hero-line {
  width: 36px; height: 1px;
  background: var(--ink-ghost); margin: 0 auto 18px;
}
.hero-quote {
  font-size: 13px; color: var(--ink-mid);
  letter-spacing: 6px; font-weight: 200;
}

/* 滚动提示 */
.scroll-hint {
  display: flex; flex-direction: column;
  align-items: center; gap: 10px;
}
.scroll-track {
  width: 1px; height: 48px;
  background: var(--ink-ghost); position: relative;
}
.scroll-progress {
  width: 100%; height: 50%;
  background: var(--ink-light);
  animation: scroll-move 2s ease-in-out infinite;
}
@keyframes scroll-move {
  0%, 100% { transform: translateY(-100%); }
  50% { transform: translateY(100%); }
}
.scroll-hint span {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 9px; letter-spacing: 6px;
  color: var(--ink-faint); font-weight: 300;
}

/* ===== 反白深色段 ===== */
.dark-section {
  position: relative; z-index: 1;
  padding: 120px 24px;
  background: var(--ink-strong);
  overflow: hidden;
}
.dark-bg-ink {
  position: absolute; inset: 0;
  background:
    radial-gradient(ellipse 80% 40% at 30% 50%, rgba(60,60,60,0.5) 0%, transparent 60%),
    radial-gradient(ellipse 60% 50% at 70% 30%, rgba(80,80,80,0.3) 0%, transparent 50%),
    radial-gradient(ellipse 40% 60% at 50% 80%, rgba(40,40,40,0.4) 0%, transparent 40%);
}
.dark-content {
  position: relative; max-width: 720px; margin: 0 auto;
}
.dark-frame {
  position: relative; border: 1px solid rgba(255,255,255,0.06);
  padding: 48px 40px; background: rgba(255,255,255,0.02);
}
.dark-corner {
  position: absolute; width: 24px; height: 24px;
  border-color: rgba(255,255,255,0.1); border-style: solid;
}
.dark-corner.tl { top: 6px; left: 6px; border-width: 1px 0 0 1px; }
.dark-corner.tr { top: 6px; right: 6px; border-width: 1px 1px 0 0; }
.dark-corner.bl { bottom: 6px; left: 6px; border-width: 0 0 1px 1px; }
.dark-corner.br { bottom: 6px; right: 6px; border-width: 0 1px 1px 0; }
.dark-grid {
  display: flex; gap: 36px; align-items: flex-start;
}
.dark-seal {
  display: flex; flex-direction: column; align-items: center; gap: 10px; flex-shrink: 0;
}
.dark-seal-inner {
  width: 56px; height: 56px;
  border: 2px solid rgba(184, 50, 42, 0.7);
  display: flex; align-items: center; justify-content: center;
  font-family: 'Ma Shan Zheng', cursive; font-size: 22px;
  color: rgba(184, 50, 42, 0.8);
  position: relative;
}
.dark-seal-inner::after {
  content: ''; position: absolute; inset: 4px;
  border: 1px solid rgba(184, 50, 42, 0.3);
}
.dark-seal span {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 8px; letter-spacing: 4px;
  color: rgba(255,255,255,0.25);
}
.dark-text { flex: 1; }
.dark-line {
  color: rgba(255,255,255,0.55);
  font-size: 15px; line-height: 2.2; font-weight: 200;
  margin-bottom: 8px;
}
.dark-em { color: rgba(255,255,255,0.85); font-weight: 700; }
.dark-divider {
  width: 40px; height: 1px;
  background: rgba(255,255,255,0.08);
  margin: 20px 0;
}
.dark-tech {
  color: rgba(255,255,255,0.35);
  font-size: 13px; line-height: 2; font-weight: 200;
}
.dark-tech strong { color: rgba(255,255,255,0.6); font-weight: 400; }

/* ===== 通用段落 ===== */
.scroll-section {
  position: relative; z-index: 1;
  padding: 100px 24px;
  display: flex; flex-direction: column; align-items: center;
}

.section-label-wrap {
  display: flex; align-items: baseline; gap: 16px; margin-bottom: 56px;
}
.section-number {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px; letter-spacing: 3px;
  color: var(--ink-faint); font-weight: 300;
}
.section-title-cn {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 14px; letter-spacing: 10px;
  font-weight: 300; color: var(--ink-mid);
}
.section-en {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 9px; letter-spacing: 4px;
  color: var(--ink-ghost); font-weight: 300;
}

/* ===== 世代流程 ===== */
.gen-flow {
  display: flex; align-items: stretch; gap: 0;
  max-width: 880px; width: 100%; padding: 0 16px;
}

.gen-card-wrap {
  flex: 1; display: flex; align-items: center;
}

.gen-card {
  flex: 1; padding: 28px 12px 20px;
  text-align: center;
  background: rgba(255,255,255,0.2);
  backdrop-filter: blur(8px);
  border: 1px solid var(--glass-border);
  transition: all 0.5s ease;
  position: relative;
}
.gen-card:hover {
  background: rgba(255,255,255,0.4);
  transform: translateY(-4px);
  border-color: rgba(0,0,0,0.06);
}

.gen-card::before {
  content: '';
  position: absolute; top: 0; left: 15%;
  width: 70%; height: 2px;
  background: linear-gradient(90deg, transparent, var(--ink-faint), transparent);
  opacity: 0.1;
}

.gen-trigram {
  font-size: 24px; color: var(--ink-faint);
  margin-bottom: 8px; opacity: 0.4;
}
.gen-num {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 9px; letter-spacing: 3px;
  color: var(--ink-faint); margin-bottom: 6px; font-weight: 300;
}
.gen-name {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 28px; color: var(--ink-strong); margin-bottom: 4px;
}
.gen-phrase {
  font-size: 11px; color: var(--ink-light);
  letter-spacing: 2px; margin-bottom: 10px; font-weight: 300;
}
.gen-dash {
  width: 20px; height: 1px;
  background: var(--ink-ghost); margin: 0 auto 10px;
}
.gen-desc {
  font-size: 11px; color: var(--ink-light);
  line-height: 1.7; font-weight: 300;
}

.gen-arrow {
  flex: 0 0 24px;
  display: flex; align-items: center; justify-content: center;
  opacity: 0.5;
}

/* ===== 品阶轨道 ===== */
.tier-universe {
  position: relative;
  width: 400px; height: 200px;
  margin-bottom: 36px;
}

.tier-orbit-svg {
  position: absolute; inset: 0;
  width: 100%; height: 100%;
}

.tier-orb {
  position: absolute;
  top: 50%; left: 50%;
  width: 52px; height: 52px;
  transform: translate(-50%, -50%);
  transition: all 0.6s ease;
  animation: orb-rotate 12s linear infinite;
  animation-delay: var(--delay, 0s);
}

.tier-orb:hover { animation-play-state: paused; }

@keyframes orb-rotate {
  0% { transform: translate(-50%, -50%) rotate(var(--angle, 0deg)) translateX(var(--rx, 100px)); }
  100% { transform: translate(-50%, -50%) rotate(calc(var(--angle, 0deg) + 360deg)) translateX(var(--rx, 100px)); }
}

.orb-inner {
  width: 52px; height: 52px;
  border-radius: 50%;
  border: 1px solid rgba(0,0,0,0.08);
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  background: rgba(255,255,255,0.3);
  backdrop-filter: blur(6px);
  transition: all 0.4s ease;
  position: relative;
  z-index: 1;
}

.tier-orb.active .orb-inner {
  border-color: var(--ink);
  background: rgba(255,255,255,0.5);
}

.orb-inner:hover {
  transform: scale(1.1);
  border-color: rgba(0,0,0,0.15);
}

.orb-char {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 20px; color: var(--ink-strong); line-height: 1;
}

.orb-label {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 8px; color: var(--ink-faint);
  letter-spacing: 2px; margin-top: 1px;
}

.orb-glow {
  position: absolute; inset: -4px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(0,0,0,0.04) 0%, transparent 70%);
  opacity: 0; transition: opacity 0.4s;
  pointer-events: none;
}

.tier-orb:hover .orb-glow,
.tier-orb.active .orb-glow {
  opacity: 1;
  animation: glow-pulse 2s ease-in-out infinite alternate;
}

@keyframes glow-pulse {
  0% { transform: scale(0.9); opacity: 0.2; }
  100% { transform: scale(1.3); opacity: 0.5; }
}

/* 品阶图例 */
.tier-legend {
  display: flex; gap: 20px; flex-wrap: wrap; justify-content: center; max-width: 600px;
}
.legend-item {
  display: flex; align-items: center; gap: 6px;
}
.legend-char {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 18px; color: var(--ink-light);
}
.legend-meaning {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px; color: var(--ink-faint); letter-spacing: 1px;
}

/* ===== 底栏 ===== */
footer {
  position: relative; z-index: 1;
  padding: 0 24px 40px;
  text-align: center;
}

.footer-wave {
  width: 100%; height: 40px; margin-bottom: 32px;
}
.footer-wave svg { width: 100%; height: 100%; display: block; }

.footer-inner {
  display: flex; flex-direction: column; align-items: center; gap: 16px;
}

.footer-brand {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 22px; letter-spacing: 10px;
  color: var(--ink-faint);
}

.footer-divider {
  width: 40px; height: 1px;
  background: var(--ink-ghost);
}

.footer-info {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px; color: var(--ink-ghost);
  letter-spacing: 4px; font-weight: 300;
  display: flex; gap: 8px;
}

.footer-dot { color: var(--ink-ghost); }

.footer-link {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px; color: var(--ink-light);
  text-decoration: none; letter-spacing: 5px;
  transition: color 0.3s; font-weight: 300;
}
.footer-link:hover { color: var(--ink-strong); }

/* ===== 滚动揭示 ===== */
.reveal {
  opacity: 0; transform: translateY(28px);
  transition: opacity 0.9s cubic-bezier(0.22, 1, 0.36, 1),
              transform 0.9s cubic-bezier(0.22, 1, 0.36, 1);
}
.reveal.show { opacity: 1; transform: translateY(0); }

/* ===== 响应式 ===== */
@media (max-width: 768px) {
  .hero h1 { font-size: 52px; letter-spacing: 24px; }
  .hero-main { gap: 20px; }
  .seal-stamp { width: 48px; height: 48px; font-size: 13px; }
  .vertical-text { display: none; }
  .dark-grid { flex-direction: column; align-items: center; }
  .dark-frame { padding: 32px 20px; }
  .gen-flow { flex-wrap: wrap; }
  .gen-card-wrap { flex: 0 0 45%; margin-bottom: 16px; }
  .gen-arrow { display: none; }
  .tier-universe { width: 300px; height: 160px; transform: scale(0.85); }
}

@media (max-width: 400px) {
  .hero h1 { font-size: 38px; letter-spacing: 16px; }
  .seal-stamp { display: none; }
  .hero-quote { font-size: 11px; letter-spacing: 4px; }
  .gen-card-wrap { flex: 0 0 100%; }
  .gen-name { font-size: 24px; }
}
</style>
