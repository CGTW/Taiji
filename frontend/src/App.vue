<script setup>
import { ref, onMounted, onUnmounted, computed, watch, nextTick } from 'vue'

const generations = [
  { num: '一', name: '太极', phrase: '混沌未分 · 万物之源', desc: '元初智能之纯粹形态，混沌中蕴含一切可能', trigram: '☰', yao: '———' },
  { num: '二', name: '两仪', phrase: '阴阳初判 · 天地始分', desc: '辩证思考，认知分化，化一为二', trigram: '☵', yao: '— —' },
  { num: '三', name: '四象', phrase: '少阴少阳 · 老阴老阳', desc: '多维感知与理解，见微知著，识变从宜', trigram: '☲', yao: '———' },
  { num: '四', name: '八卦', phrase: '天地雷风 · 水火山泽', desc: '八种智能形态通达无碍，应变无穷', trigram: '☯', yao: '— —' }
]

const tiers = [
  { char: '元', label: '标准', meaning: '万物之始' },
  { char: '玄', label: '进阶', meaning: '众妙之门' },
  { char: '灵', label: '高阶', meaning: '通灵达变' },
  { char: '极', label: '旗舰', meaning: '登峰造极' },
  { char: '无', label: '至尊', meaning: '无极无限' },
  { char: '道', label: '终极', meaning: '万法归一' }
]

const capabilities = [
  { icon: '☰', title: '多元感知', desc: '多模态输入融合，图像、文本、语音无碍互通，如太极之包罗万象' },
  { icon: '☷', title: '辩证推理', desc: '阴阳互济之思考框架，矛盾中觅和谐，混沌中见秩序' },
  { icon: '☵', title: '记忆之渊', desc: '似水善利万物而不争，长短期记忆交融，知古鉴今' },
  { icon: '☲', title: '明察洞见', desc: '如火之明照万象，数据分析洞察入微，于无声处听惊雷' },
  { icon: '☳', title: '迅疾响应', desc: '雷动风行之执行速度，毫秒之间决断千里' },
  { icon: '☴', title: '柔性编排', desc: '风行草偃之灵活调度，跨系统协作游刃有余' },
  { icon: '☶', title: '稳如山岳', desc: '艮止之道，安全可靠，坚不可摧之企业级保障' },
  { icon: '☱', title: '悦目呈现', desc: '泽被万物之美，交互优雅自然，人机相得益彰' }
]

const quotes = [
  { text: '道可道，非常道；名可名，非常名。', source: '道德经', chapter: '第一章' },
  { text: '大方无隅，大器晚成，大音希声，大象无形。', source: '道德经', chapter: '第四十一章' },
  { text: '知者不言，言者不知。', source: '道德经', chapter: '第五十六章' },
  { text: '人法地，地法天，天法道，道法自然。', source: '道德经', chapter: '第二十五章' }
]

const currentView = ref('home')

const sections = ['hero', 'intro', 'quotes', 'features', 'generations', 'tiers', 'footer']
const navLabels = ['太极', '道', '经', '用', '化', '品', '承']

const scrollY = ref(0)
const techParticles = ref([])
const inkDrops = ref([])
const mouseInk = ref([])
const observer = ref(null)
const scrollProgress = ref(0)
const activeSection = ref(0)
const loaded = ref(false)
const inkWashReveal = ref(true)
const canvasRef = ref(null)
const inkOverlayOpacity = ref(0)
const typedChars = ref(0)
const brushVisible = ref([false, false, false, false, false, false])
const brushX = ref(-100)
const brushY = ref(-100)
const brushRotate = ref(-30)
const brushScale = ref(1)
let prevMX = 0
let prevMY = 0

const messages = ref([])
const inputMessage = ref('')
const chatLoading = ref(false)
const chatContainer = ref(null)
const chatInputRef = ref(null)

let msgId = 0
function addMessage(role, content) {
  const id = ++msgId
  messages.value.push({ role, content, id })
  return id
}

let pendingAiId = null

function sendMessage() {
  const msg = inputMessage.value.trim()
  if (!msg || chatLoading.value) return
  inputMessage.value = ''
  addMessage('user', msg)
  chatLoading.value = true
  pendingAiId = null

  const eventSource = new EventSource(`/chat/taiji/chat?msg=${encodeURIComponent(msg)}`)

  eventSource.onmessage = (event) => {
    if (!pendingAiId) {
      pendingAiId = addMessage('ai', event.data)
    } else {
      const target = messages.value.find(m => m.id === pendingAiId)
      if (target) {
        target.content += event.data
        messages.value = [...messages.value]
      }
    }
  }

  eventSource.onerror = () => {
    eventSource.close()
    chatLoading.value = false
    if (!pendingAiId) {
      addMessage('ai', '抱歉，AI 服务暂时不可用，请稍后重试。')
    }
    pendingAiId = null
  }
}

function onChatKeydown(e) {
  if (e.key === 'Enter' && !e.shiftKey) {
    e.preventDefault()
    sendMessage()
  }
}

watch(messages, () => {
  nextTick(() => {
    const el = chatContainer.value?.querySelector('.chat-messages')
    if (el) el.scrollTop = el.scrollHeight
  })
}, { deep: true })

const quote = '道生一 · 一生二 · 二生三 · 三生万物'
const typedQuote = computed(() => quote.slice(0, typedChars.value))

onMounted(() => {
  setTimeout(() => { loaded.value = true }, 100)
  setTimeout(() => { inkWashReveal.value = false }, 2000)

  let charIdx = 0
  const typeInterval = setInterval(() => {
    charIdx++
    typedChars.value = charIdx
    if (charIdx >= quote.length) clearInterval(typeInterval)
  }, 120)

  for (let i = 0; i < 30; i++) {
    techParticles.value.push({
      id: i, size: 1 + Math.random() * 2.5, x: Math.random() * 100, y: Math.random() * 100,
      dur: 25 + Math.random() * 45, delay: Math.random() * 20, drift: -30 + Math.random() * 60
    })
  }

  for (let i = 0; i < 8; i++) {
    inkDrops.value.push({
      id: i, left: 10 + Math.random() * 80, delay: Math.random() * 10, dur: 3 + Math.random() * 4, size: 2 + Math.random() * 6
    })
  }

  window.addEventListener('scroll', onScroll, { passive: true })
  document.addEventListener('mousemove', onMouseMove)
  document.addEventListener('mouseleave', () => { brushX.value = -200; brushY.value = -200 })

  observer.value = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('show')
        observer.value.unobserve(entry.target)
      }
    })
  }, { threshold: 0.08 })

  document.querySelectorAll('.reveal').forEach(el => observer.value.observe(el))

  const sectionObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const idx = sections.indexOf(entry.target.id)
        if (idx >= 0) activeSection.value = idx
      }
    })
  }, { threshold: 0.3, rootMargin: '-80px 0px -80px 0px' })

  sections.forEach(id => {
    const el = document.getElementById(id)
    if (el) sectionObserver.observe(el)
  })

  let lastSection = 0
  window.addEventListener('scroll', () => {
    const current = activeSection.value
    if (current !== lastSection) {
      inkOverlayOpacity.value = 0.6
      setTimeout(() => { inkOverlayOpacity.value = 0 }, 600)
      lastSection = current
    }
  }, { passive: true })

  const brushObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const idx = Number(entry.target.dataset.idx)
        if (!isNaN(idx)) brushVisible.value[idx] = true
      }
    })
  }, { threshold: 0.3 })

  document.querySelectorAll('.brush-divider').forEach(el => brushObserver.observe(el))

  initCanvas()
})

let particles = []
let mouse = { x: -1000, y: -1000 }
let animId = null

function initCanvas() {
  const canvas = canvasRef.value
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  resizeCanvas(canvas)
  window.addEventListener('resize', () => resizeCanvas(canvas))

  for (let i = 0; i < 18; i++) {
    particles.push({
      x: Math.random() * canvas.width,
      y: Math.random() * canvas.height,
      r: 60 + Math.random() * 200,
      dx: (Math.random() - 0.5) * 0.15,
      dy: (Math.random() - 0.5) * 0.15,
      opacity: 0.012 + Math.random() * 0.025,
      phase: Math.random() * Math.PI * 2
    })
  }

  function animate() {
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    const scroll = scrollY.value

    for (const p of particles) {
      p.x += p.dx + Math.sin(Date.now() * 0.0003 + p.phase) * 0.05
      p.y += p.dy + Math.cos(Date.now() * 0.0004 + p.phase) * 0.05

      const mx = mouse.x - p.x
      const my = mouse.y - p.y
      const dist = Math.sqrt(mx * mx + my * my)
      if (dist < 300) {
        p.x -= mx * 0.002
        p.y -= my * 0.002
      }

      if (p.x < -p.r) p.x = canvas.width + p.r
      if (p.x > canvas.width + p.r) p.x = -p.r
      if (p.y < -p.r) p.y = canvas.height + p.r
      if (p.y > canvas.height + p.r) p.y = -p.r

      const yOff = scroll * (0.03 + (p.opacity * 10))
      const grad = ctx.createRadialGradient(p.x, p.y + yOff, 0, p.x, p.y + yOff, p.r)
      grad.addColorStop(0, `rgba(40,45,55,${p.opacity})`)
      grad.addColorStop(0.4, `rgba(40,45,55,${p.opacity * 0.5})`)
      grad.addColorStop(1, 'rgba(40,45,55,0)')
      ctx.fillStyle = grad
      ctx.beginPath()
      ctx.arc(p.x, p.y + yOff, p.r, 0, Math.PI * 2)
      ctx.fill()
    }

    animId = requestAnimationFrame(animate)
  }

  animate()
}

function resizeCanvas(canvas) {
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight
}

function onScroll() {
  scrollY.value = window.scrollY
  const docEl = document.documentElement
  scrollProgress.value = scrollY.value / (docEl.scrollHeight - docEl.clientHeight)
}

function onMouseMove(e) {
  mouse.x = e.clientX
  mouse.y = e.clientY
  brushX.value = e.clientX
  brushY.value = e.clientY

  const dx = e.clientX - prevMX
  const dy = e.clientY - prevMY
  const speed = Math.sqrt(dx * dx + dy * dy)
  if (speed > 1) {
    brushRotate.value = Math.atan2(dy, dx) * (180 / Math.PI) - 90
    brushScale.value = Math.min(1.6, Math.max(0.5, 1 - speed * 0.008))
  }
  prevMX = e.clientX
  prevMY = e.clientY

  mouseInk.value.push({ x: e.clientX, y: e.clientY, life: 1, speed })
  if (mouseInk.value.length > 20) mouseInk.value.shift()
  mouseInk.value = mouseInk.value.map(d => ({ ...d, life: d.life - 0.035 })).filter(d => d.life > 0)
}

function scrollToSection(idx) {
  const el = document.getElementById(sections[idx])
  if (el) el.scrollIntoView({ behavior: 'smooth' })
}

onUnmounted(() => {
  if (animId) cancelAnimationFrame(animId)
  window.removeEventListener('scroll', onScroll)
  document.removeEventListener('mousemove', onMouseMove)
  observer.value?.disconnect()
})
</script>

<template>
  <!-- 载入水墨揭示 -->
  <div class="load-reveal" :class="{ 'load-reveal--done': !inkWashReveal }">
    <div class="load-reveal-inner" />
    <div class="load-reveal-text">太 极</div>
  </div>

  <!-- 滚动进度条 -->
  <div class="scroll-progress-bar" :style="{ width: scrollProgress * 100 + '%' }" />

  <!-- 水墨转场遮罩 -->
  <div class="ink-overlay" :style="{ opacity: inkOverlayOpacity }" />

  <!-- 顶部导航 -->
  <nav class="top-nav" :class="{ 'top-nav--visible': loaded }">
    <div class="top-nav-brand" @click="currentView = 'home'">太 极</div>
    <div class="top-nav-links">
      <span class="top-nav-item" :class="{ active: currentView === 'home' }" @click="currentView = 'home'">首 页</span>
      <span class="top-nav-item" :class="{ active: currentView === 'chat' }" @click="currentView = 'chat'">聊 天</span>
    </div>
  </nav>

  <div v-if="currentView === 'home'">
  <!-- 固定导航 -->
  <nav class="ink-nav" :class="{ 'ink-nav--visible': loaded }">
    <div v-for="(label, i) in navLabels" :key="i" class="ink-nav-item" :class="{ active: activeSection === i }" @click="scrollToSection(i)">
      <div class="ink-nav-dot" />
      <span class="ink-nav-label">{{ label }}</span>
    </div>
  </nav>

  <!-- Canvas 水墨粒子 -->
  <canvas ref="canvasRef" class="ink-canvas" />

  <!-- 科技粒子 -->
  <div class="tech-particles">
    <div v-for="p in techParticles" :key="p.id" class="t-particle" :style="{
      width: p.size + 'px', height: p.size + 'px',
      left: p.x + '%', top: p.y + '%',
      animationDuration: p.dur + 's', animationDelay: p.delay + 's',
      '--drift': p.drift + 'px'
    }" />
  </div>

  <!-- 墨滴 -->
  <div class="ink-drip-container">
    <div v-for="d in inkDrops" :key="d.id" class="ink-drip" :style="{
      left: d.left + '%', animationDelay: d.delay + 's',
      animationDuration: d.dur + 's', width: d.size + 'px', height: d.size + 'px'
    }" />
  </div>

  <!-- 毛笔光标（只在首页显示） -->
  <div v-if="currentView === 'home'" class="brush-cursor" :style="{ left: brushX + 'px', top: brushY + 'px', transform: 'translate(-50%, -50%) rotate(' + brushRotate + 'deg) scale(' + brushScale + ')' }">
    <div class="brush-tip" />
    <div class="brush-ink-drop" />
  </div>

  <!-- 墨迹拖尾 -->
  <div v-if="currentView === 'home'" class="mouse-ink">
    <div v-for="(m, i) in mouseInk" :key="i" class="m-ink-dot" :style="{
      left: m.x + 'px', top: m.y + 'px',
      opacity: m.life * (0.08 + Math.min(1, m.speed * 0.01)), transform: 'scale(' + (1 - m.life) * m.speed * 0.06 + ')',
      width: Math.min(20, 6 + m.speed * 0.2) + 'px'
    }" />
  </div>

  <!-- 科技网格 -->
  <div class="tech-grid" :style="{ maskPosition: '0 ' + scrollY * 0.3 + 'px' }" />

  <!-- SVG 墨迹 -->
  <svg class="ink-splash" viewBox="0 0 1200 800" preserveAspectRatio="xMidYMid slice">
    <path d="M200 300 Q400 100 600 250 Q800 400 700 600 Q600 750 400 650 Q200 550 200 300Z" fill="rgba(0,0,0,0.01)" />
    <path d="M900 200 Q1050 150 1100 300 Q1150 500 1000 550 Q850 600 900 400 Q880 300 900 200Z" fill="rgba(0,0,0,0.008)" />
    <path d="M300 600 Q450 500 550 650 Q650 800 500 780 Q300 750 300 600Z" fill="rgba(0,0,0,0.006)" />
    <path d="M100 100 Q200 50 350 120 Q500 200 400 350 Q300 500 150 400 Q0 300 100 100Z" fill="rgba(0,0,0,0.004)" />
    <path d="M850 600 Q950 550 1050 650 Q1150 750 1000 800 Q850 850 800 700 Q780 650 850 600Z" fill="rgba(0,0,0,0.005)" />
  </svg>

  <!-- ===== HERO ===== -->
  <section id="hero" class="hero">
    <div class="hero-bg-layer" />
    <div class="hero-inner">
      <div class="hero-top reveal"><span class="hero-badge">DIGITAL · 智慧</span></div>
      <div class="hero-main reveal" :style="{ transform: 'translateY(' + scrollY * -0.15 + 'px)', opacity: Math.max(0, 1 - scrollY / 500) }">
        <div class="seal-stamp"><span>太<br>极</span></div>
        <div class="hero-center">
          <div class="logo-crown">
            <div class="crown-ring" /><div class="crown-ring crown-ring-2" /><div class="crown-ring crown-ring-3" />
            <img src="/logo.png" alt="太极">
          </div>
          <h1>太 极</h1>
          <p class="hero-roman">TAIJI</p>
          <div class="hero-line" />
          <p class="hero-quote">
            <span v-for="(ch, i) in quote" :key="i" class="type-char" :class="{ visible: i < typedChars }">{{ ch }}</span>
            <span class="type-cursor" :class="{ blink: typedChars >= quote.length }">|</span>
          </p>
        </div>
        <div class="vertical-text">智 能 之 源</div>
      </div>
      <div class="scroll-hint reveal" :style="{ opacity: Math.max(0, 1 - scrollY / 300) }">
        <div class="scroll-track"><div class="scroll-progress" /></div>
        <span>卷 轴 徐 展</span>
      </div>
    </div>
  </section>

  <!-- 笔触分界 -->
  <div class="brush-divider" data-idx="0" :class="{ drawn: brushVisible[0] }" :style="{ transform: 'translateX(' + scrollY * -0.05 + 'px)' }">
    <svg viewBox="0 0 1200 60" preserveAspectRatio="none"><path class="brush-path" d="M0 30 Q100 10 200 35 Q300 55 400 25 Q500 5 600 30 Q700 50 800 20 Q900 5 1000 28 Q1100 48 1200 15" fill="none" stroke="rgba(0,0,0,0.04)" stroke-width="6" stroke-linecap="round"/></svg>
  </div>

  <!-- ===== INTRO ===== -->
  <section id="intro" class="dark-section">
    <div class="dark-bg-ink" />
    <div class="dark-content reveal">
      <div class="dark-frame">
        <div class="dark-corner tl" /><div class="dark-corner tr" /><div class="dark-corner bl" /><div class="dark-corner br" />
        <div class="dark-frame-ink" />
        <div class="bagua-deco">
          <span class="bagua-char">☰</span><span class="bagua-char">☷</span><span class="bagua-char">☵</span><span class="bagua-char">☲</span>
          <span class="bagua-char">☳</span><span class="bagua-char">☴</span><span class="bagua-char">☶</span><span class="bagua-char">☱</span>
        </div>
        <div class="dark-grid">
          <div class="dark-seal">
            <div class="dark-seal-inner">道</div>
            <span>法 · 自 · 然</span>
          </div>
          <div class="dark-text">
            <p class="dark-line"><span class="dark-em">太极</span> 者，宇宙万物之起源也。</p>
            <p class="dark-line">无形无象，而涵摄一切可能。</p>
            <p class="dark-line">静极而动，动极而静，化生两仪，衍生四象，演为八卦，终成万象。</p>
            <div class="dark-divider" />
            <p class="dark-tech"><strong>Taiji</strong> 非唯 Agent 平台而已——<br>乃东方哲思于数字世界之延续，<br>古老智慧与现代计算之交汇。</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- 笔触分界 -->
  <div class="brush-divider brush-divider--rev" data-idx="1" :class="{ drawn: brushVisible[1] }" :style="{ transform: 'translateX(' + scrollY * 0.05 + 'px)' }">
    <svg viewBox="0 0 1200 60" preserveAspectRatio="none"><path class="brush-path" d="M0 30 Q100 50 200 20 Q300 5 400 35 Q500 55 600 25 Q700 10 800 40 Q900 55 1000 30 Q1100 10 1200 40" fill="none" stroke="rgba(0,0,0,0.03)" stroke-width="4" stroke-linecap="round"/></svg>
  </div>

  <!-- ===== QUOTES ===== -->
  <section id="quotes" class="scroll-section quotes-section">
    <div class="section-label-wrap reveal">
      <span class="section-number">经</span>
      <h2 class="section-title-cn">先贤之言</h2>
      <span class="section-en">WISDOM</span>
    </div>
    <div class="quotes-timeline">
      <div v-for="(q, i) in quotes" :key="i" class="quote-item reveal" :style="{ transitionDelay: i * 0.15 + 's' }">
        <div class="quote-line-connector" />
        <div class="quote-char">{{ ['道','大','知','人'][i] }}</div>
        <div class="quote-content">
          <p class="quote-text">「{{ q.text }}」</p>
          <div class="quote-attrib">
            <span class="quote-source">{{ q.source }}</span>
            <span class="quote-sep">·</span>
            <span class="quote-chapter">{{ q.chapter }}</span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- 笔触分界 -->
  <div class="brush-divider" data-idx="2" :class="{ drawn: brushVisible[2] }" :style="{ transform: 'translateX(' + scrollY * -0.03 + 'px)' }">
    <svg viewBox="0 0 1200 60" preserveAspectRatio="none"><path class="brush-path" d="M0 25 Q120 15 240 30 Q360 45 480 20 Q600 5 720 28 Q840 48 960 22 Q1080 10 1200 35" fill="none" stroke="rgba(0,0,0,0.035)" stroke-width="5" stroke-linecap="round"/></svg>
  </div>

  <!-- ===== FEATURES ===== -->
  <section id="features" class="scroll-section">
    <div class="section-label-wrap reveal">
      <span class="section-number">用</span>
      <h2 class="section-title-cn">太极之用</h2>
      <span class="section-en">CAPABILITIES</span>
    </div>

    <div class="features-grid">
      <div v-for="(c, i) in capabilities" :key="c.title" class="feature-card reveal" :style="{ transitionDelay: i * 0.06 + 's' }">
        <div class="feature-icon">{{ c.icon }}</div>
        <h3 class="feature-title">{{ c.title }}</h3>
        <p class="feature-desc">{{ c.desc }}</p>
        <div class="feature-ink" />
        <div class="feature-ink-hover" />
      </div>
    </div>
  </section>

  <!-- 笔触分界 -->
  <div class="brush-divider brush-divider--rev" data-idx="3" :class="{ drawn: brushVisible[3] }" :style="{ transform: 'translateX(' + scrollY * 0.04 + 'px)' }">
    <svg viewBox="0 0 1200 60" preserveAspectRatio="none"><path class="brush-path" d="M0 35 Q150 15 300 40 Q450 55 600 20 Q750 5 900 30 Q1050 50 1200 25" fill="none" stroke="rgba(0,0,0,0.03)" stroke-width="4" stroke-linecap="round"/></svg>
  </div>

  <!-- ===== GENERATIONS ===== -->
  <section id="generations" class="scroll-section">
    <div class="section-label-wrap reveal">
      <span class="section-number">化</span>
      <h2 class="section-title-cn">世代演化</h2>
      <span class="section-en">GENERATIONS</span>
    </div>

    <div class="gen-scroll-container">
      <div v-for="(g, i) in generations" :key="g.name" class="gen-card-wrap reveal" :style="{ transitionDelay: i * 0.12 + 's' }">
        <div class="gen-card" @mousemove="e => { const r = e.currentTarget.getBoundingClientRect(); e.currentTarget.style.setProperty('--hover-y', ((e.clientY - r.top) / r.height - 0.5) * -8 + 'px'); e.currentTarget.style.setProperty('--hover-x', ((e.clientX - r.left) / r.width - 0.5) * 4 + 'deg') }" @mouseleave="e => { e.currentTarget.style.setProperty('--hover-y', '0px'); e.currentTarget.style.setProperty('--hover-x', '0deg') }">
          <div class="gen-yao">{{ g.yao }}</div>
          <div class="gen-trigram">{{ g.trigram }}</div>
          <div class="gen-num">GEN · {{ g.num }}</div>
          <div class="gen-name">{{ g.name }}</div>
          <div class="gen-phrase">{{ g.phrase }}</div>
          <div class="gen-dash" />
          <div class="gen-desc">{{ g.desc }}</div>
        </div>
        <div v-if="i < generations.length - 1" class="gen-arrow">
          <svg width="20" height="20" viewBox="0 0 20 20"><path d="M4 10h12M11 4l6 6-6 6" fill="none" stroke="#c5bfb5" stroke-width="0.5"/></svg>
        </div>
      </div>
    </div>

    <div class="gen-quote reveal">
      <div class="gen-quote-line" />
      <p>太极混沌 · 两仪分化 · 四象洞察 · 八卦通达</p>
      <div class="gen-quote-line" />
    </div>
  </section>

  <!-- 笔触分界 -->
  <div class="brush-divider" data-idx="4" :class="{ drawn: brushVisible[4] }" :style="{ transform: 'translateX(' + scrollY * -0.04 + 'px)' }">
    <svg viewBox="0 0 1200 60" preserveAspectRatio="none"><path class="brush-path" d="M0 20 Q200 40 400 15 Q600 5 800 30 Q1000 45 1200 20" fill="none" stroke="rgba(0,0,0,0.03)" stroke-width="5" stroke-linecap="round"/></svg>
  </div>

  <!-- ===== TIERS ===== -->
  <section id="tiers" class="scroll-section">
    <div class="section-label-wrap reveal">
      <span class="section-number">品</span>
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
        :style="{ '--angle': (i * 60) + 'deg', '--delay': i * 0.08 + 's', '--rx': (180 - i * 25) + 'px', '--ry': (60 - i * 14) + 'px' }">
        <div class="orb-inner"><span class="orb-char">{{ t.char }}</span><span class="orb-label">{{ t.label }}</span></div>
        <div class="orb-glow" />
      </div>
    </div>

    <div class="tier-legend reveal">
      <div v-for="t in tiers" :key="t.char" class="legend-item">
        <span class="legend-char">{{ t.char }}</span>
        <span class="legend-meaning">{{ t.meaning }}</span>
        <span class="legend-sep">·</span>
      </div>
    </div>

    <div class="tier-example reveal">
      <span class="tier-example-label">命名示例</span>
      <div class="tier-example-group">
        <span class="example-tag">太极 · 元</span>
        <span class="example-tag">两仪 · 玄</span>
        <span class="example-tag">四象 · 极</span>
        <span class="example-tag">八卦 · 道</span>
      </div>
    </div>
  </section>

  <!-- ===== FOOTER ===== -->
  <footer id="footer">
    <div class="footer-wave">
      <svg viewBox="0 0 1200 40" preserveAspectRatio="none">
        <path d="M0 20 Q150 0 300 15 Q450 30 600 10 Q750 0 900 18 Q1050 35 1200 8 L1200 40 L0 40Z" fill="rgba(0,0,0,0.025)" />
        <path d="M0 30 Q200 10 400 25 Q600 40 800 20 Q1000 5 1200 25 L1200 40 L0 40Z" fill="rgba(0,0,0,0.015)" />
      </svg>
    </div>
    <div class="footer-inner reveal">
      <div class="footer-hex">☯</div>
      <div class="footer-brand">太 极</div>
      <div class="footer-divider" />
      <div class="footer-tagline">道法自然 · 智周万物</div>
      <div class="footer-info"><span>基于 Spring AI</span><span class="footer-dot">·</span><span>根植中国文化</span></div>
      <div class="footer-links">
        <a class="footer-link" href="https://github.com/CGTW/Taiji" target="_blank">GITHUB →</a>
        <span class="footer-dot">·</span>
        <a class="footer-link" href="#">文档</a>
        <span class="footer-dot">·</span>
        <a class="footer-link" href="#">关于</a>
      </div>
    </div>
  </footer>
  </div>

  <!-- ===== 聊天页（独立视图） ===== -->
  <div v-else class="chat-page">
    <!-- 背景墨迹装饰 -->
    <svg class="chat-bg-ink" viewBox="0 0 1200 800" preserveAspectRatio="xMidYMid slice">
      <path d="M200 100 Q400 50 600 200 Q800 350 700 550 Q600 700 400 600 Q200 500 200 100Z" fill="rgba(0,0,0,0.015)" />
      <path d="M850 150 Q1000 100 1050 250 Q1100 450 950 500 Q800 550 850 350 Q830 250 850 150Z" fill="rgba(0,0,0,0.012)" />
      <path d="M300 600 Q450 500 550 650 Q650 800 500 750 Q300 700 300 600Z" fill="rgba(0,0,0,0.008)" />
      <path d="M100 500 Q200 450 350 520 Q500 600 400 700 Q300 800 150 750 Q0 700 100 500Z" fill="rgba(0,0,0,0.006)" />
    </svg>

    <!-- 页首 -->
    <div class="chat-page-top">
      <div class="chat-seal">聊</div>
      <div class="chat-page-title-group">
        <h1 class="chat-page-title">与AI对话</h1>
        <p class="chat-page-subtitle">太 极 智 语</p>
      </div>
      <div class="chat-hex-deco">
        <span>☰</span><span>☷</span><span>☵</span><span>☲</span>
      </div>
    </div>

    <!-- 聊天主体 -->
    <div ref="chatContainer" class="chat-box">
      <!-- 顶部装饰线 -->
      <div class="chat-box-rule">
        <svg viewBox="0 0 680 12" preserveAspectRatio="none"><path d="M0 6 Q170 0 340 6 Q510 12 680 6" fill="none" stroke="rgba(0,0,0,0.04)" stroke-width="0.5"/></svg>
      </div>

      <div class="chat-messages">
        <!-- 空状态 -->
        <div v-if="messages.length === 0" class="chat-empty">
          <div class="chat-empty-ornament">
            <div class="empty-ring" />
            <div class="empty-ring empty-ring-2" />
            <span class="empty-taiji">☯</span>
          </div>
          <p class="empty-line-1">静 待 君 言</p>
          <p class="empty-line-2">输入您的问题，开启太极智慧之旅</p>
          <div class="empty-brush">
            <svg width="120" height="8" viewBox="0 0 120 8"><path d="M0 4 Q30 1 60 4 Q90 7 120 4" fill="none" stroke="rgba(0,0,0,0.06)" stroke-width="0.5"/></svg>
          </div>
        </div>

        <!-- 消息列表 -->
        <div v-for="m in messages" :key="m.id" class="chat-msg" :class="{ 'chat-msg--user': m.role === 'user', 'chat-msg--ai': m.role === 'ai' }">
          <div class="chat-avatar" :class="{ 'chat-avatar--user': m.role === 'user', 'chat-avatar--ai': m.role === 'ai' }">
            <span v-if="m.role === 'user'" class="chat-avatar-text">君</span>
            <span v-else class="chat-avatar-text">智</span>
          </div>
          <div class="chat-bubble" :class="{ 'chat-bubble--user': m.role === 'user', 'chat-bubble--ai': m.role === 'ai' }">
            <p>{{ m.content }}</p>
          </div>
        </div>

      </div>

      <!-- 输入区 -->
      <div class="chat-input-area">
        <div class="chat-input-rule">
          <svg viewBox="0 0 680 8" preserveAspectRatio="none"><path d="M0 4 Q170 0 340 4 Q510 8 680 4" fill="none" stroke="rgba(0,0,0,0.03)" stroke-width="0.5"/></svg>
        </div>
        <div class="chat-input-wrap">
          <textarea ref="chatInputRef" v-model="inputMessage" class="chat-input" placeholder="输入您的问题…" rows="1" @keydown="onChatKeydown" :disabled="chatLoading" />
          <button class="chat-send-btn" :disabled="!inputMessage.trim() || chatLoading" @click="sendMessage">
            <span>发</span>
          </button>
        </div>
        <div class="chat-input-hint">Enter 发送 · Shift+Enter 换行</div>
      </div>
    </div>

    <!-- 底部墨迹 -->
    <svg class="chat-bg-ink chat-bg-ink--bottom" viewBox="0 0 1200 400" preserveAspectRatio="xMidYMid slice">
      <path d="M200 300 Q400 350 600 250 Q800 150 900 300 Q1000 450 700 400 Q400 350 200 300Z" fill="rgba(0,0,0,0.01)" />
    </svg>
  </div>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@200;400;700;900&family=Noto+Sans+SC:wght@200;300;400;600&family=Ma+Shan+Zheng&display=swap');

*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

:root {
  --paper: #f4efe6;
  --ink: #1a1a1a;
  --ink-strong: #0a0a0a;
  --ink-mid: #4a4a4a;
  --ink-light: #7a746a;
  --ink-faint: #b5ada0;
  --ink-ghost: #d4cdc0;
  --seal: #b8322a;
}

html { scroll-behavior: smooth; }
body {
  font-family: 'Noto Serif SC', serif;
  background: var(--paper); color: var(--ink);
  overflow-x: hidden; -webkit-font-smoothing: antialiased;
  cursor: none;
}

/* ===== 载入水墨揭示 ===== */
.load-reveal {
  position: fixed; inset: 0; z-index: 10000;
  display: flex; align-items: center; justify-content: center;
  pointer-events: all;
  transition: opacity 1.2s cubic-bezier(0.22,1,0.36,1), transform 1.2s cubic-bezier(0.22,1,0.36,1);
}
.load-reveal--done { opacity: 0; transform: scale(1.1); pointer-events: none; }
.load-reveal-inner {
  position: absolute; inset: 0;
  background: radial-gradient(ellipse 120% 80% at 50% 50%, var(--paper) 0%, var(--paper) 40%, transparent 70%);
}
.load-reveal-text {
  position: relative; z-index: 1;
  font-family: 'Ma Shan Zheng', cursive; font-size: 72px; letter-spacing: 32px;
  color: var(--ink-strong); animation: load-pulse 2s ease-in-out;
  text-shadow: 2px 2px 8px rgba(0,0,0,0.08);
}
@keyframes load-pulse {
  0% { opacity: 0; transform: scale(0.6); letter-spacing: 80px; filter: blur(8px); }
  40% { opacity: 1; transform: scale(1); letter-spacing: 32px; filter: blur(0); }
  100% { opacity: 1; transform: scale(1); letter-spacing: 32px; }
}

/* ===== 水墨转场遮罩 ===== */
.ink-overlay {
  position: fixed; inset: 0; z-index: 9998;
  pointer-events: none;
  background: radial-gradient(ellipse 80% 60% at 50% 50%, rgba(0,0,0,0.06) 0%, transparent 70%);
  transition: opacity 0.6s ease;
}

/* ===== 滚动进度条 ===== */
.scroll-progress-bar {
  position: fixed; top: 0; left: 0; height: 1px;
  background: var(--ink); opacity: 0.15;
  z-index: 100; transition: width 0.1s;
}

/* ===== Canvas 水墨 ===== */
.ink-canvas {
  position: fixed; inset: 0; z-index: 0;
  pointer-events: none; width: 100%; height: 100%;
}

/* ===== 固定导航 ===== */
.ink-nav {
  position: fixed; right: 20px; top: 50%; transform: translateY(-50%);
  z-index: 99; display: flex; flex-direction: column; gap: 20px;
  opacity: 0; transition: opacity 0.6s ease;
}
.ink-nav--visible { opacity: 1; }
.ink-nav-item {
  display: flex; align-items: center; gap: 8px;
  cursor: pointer; flex-direction: row-reverse;
  transition: all 0.3s ease;
}
.ink-nav-dot {
  width: 6px; height: 6px; border-radius: 50%;
  background: var(--ink-ghost); transition: all 0.3s ease;
  position: relative;
}
.ink-nav-dot::after {
  content: ''; position: absolute; inset: -3px;
  border-radius: 50%; border: 1px solid transparent;
  transition: all 0.3s ease;
}
.ink-nav-item.active .ink-nav-dot {
  background: var(--ink-light); width: 8px; height: 8px;
}
.ink-nav-item.active .ink-nav-dot::after {
  border-color: var(--ink-faint); inset: -4px;
}
.ink-nav-label {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 9px; color: var(--ink-ghost);
  letter-spacing: 2px; opacity: 0;
  transition: all 0.3s ease; white-space: nowrap;
}
.ink-nav-item:hover .ink-nav-label,
.ink-nav-item.active .ink-nav-label { opacity: 1; color: var(--ink-light); }
.ink-nav-item:hover .ink-nav-dot {
  background: var(--ink-light); transform: scale(1.2);
}

/* ===== 毛笔笔触分界 ===== */
.brush-divider {
  position: relative; z-index: 2; height: 40px;
  margin: -20px 0; pointer-events: none;
  will-change: transform;
}
.brush-divider svg { width: 100%; height: 100%; display: block; }
.brush-divider--rev { transform: scaleX(-1); }
.brush-path {
  stroke-dasharray: 1400; stroke-dashoffset: 1400;
  transition: stroke-dashoffset 1.8s cubic-bezier(0.22,1,0.36,1);
}
.brush-divider.drawn .brush-path { stroke-dashoffset: 0; }

.tech-particles { position: fixed; inset: 0; pointer-events: none; z-index: 1; overflow: hidden; }
.t-particle { position: absolute; border-radius: 50%; background: rgba(60, 70, 90, 0.1); animation: particle-rise linear infinite; }
@keyframes particle-rise { 0% { transform: translateY(100vh) translateX(0); opacity: 0; } 10% { opacity: 0.4; } 90% { opacity: 0.2; } 100% { transform: translateY(-10vh) translateX(var(--drift,0)); opacity: 0; } }

.ink-drip-container { position: fixed; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 0; overflow: hidden; }
.ink-drip { position: absolute; top: -10px; border-radius: 50%; background: rgba(0,0,0,0.035); animation: drip-fall linear infinite; }
@keyframes drip-fall { 0% { transform: translateY(-10px) scale(1); opacity: 0; } 10% { opacity: 0.5; } 90% { opacity: 0.2; } 100% { transform: translateY(100vh) scale(0.3); opacity: 0; } }

.brush-cursor {
  position: fixed; z-index: 10001; pointer-events: none;
  width: 32px; height: 32px;
  transition: transform 0.08s ease-out;
}

.brush-tip {
  width: 100%; height: 100%;
  background: radial-gradient(ellipse 40% 70% at 50% 20%, rgba(0,0,0,0.13) 0%, rgba(0,0,0,0.06) 40%, transparent 70%);
  border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
  filter: blur(1.5px);
}
.brush-ink-drop {
  position: absolute; bottom: -4px; left: 50%; transform: translateX(-50%);
  width: 4px; height: 4px; border-radius: 50%;
  background: rgba(0,0,0,0.06); filter: blur(2px);
  animation: drop-pulse 2s ease-in-out infinite;
}
@keyframes drop-pulse { 0%, 100% { transform: translateX(-50%) scale(1); opacity: 0.5; } 50% { transform: translateX(-50%) scale(1.4); opacity: 0.8; } }

.mouse-ink { position: fixed; inset: 0; pointer-events: none; z-index: 10000; }
.m-ink-dot { position: absolute; height: 6px; border-radius: 50%; background: rgba(0,0,0,0.03); filter: blur(3px); transform-origin: center; }

.tech-grid { position: fixed; inset: 0; pointer-events: none; z-index: 0; background-image: linear-gradient(rgba(40,50,70,0.035) 1px, transparent 1px), linear-gradient(90deg, rgba(40,50,70,0.035) 1px, transparent 1px); background-size: 64px 64px; mask-image: radial-gradient(ellipse 70% 50% at 50% 40%, black 15%, transparent 65%); -webkit-mask-image: radial-gradient(ellipse 70% 50% at 50% 40%, black 15%, transparent 65%); }

.ink-splash { position: fixed; inset: 0; width: 100%; height: 100%; pointer-events: none; z-index: 0; }

/* ===== 顶部导航 ===== */
.top-nav {
  position: fixed; top: 0; left: 0; right: 0; z-index: 100;
  display: flex; align-items: center; justify-content: space-between;
  padding: 12px 32px;
  background: rgba(244,239,230,0.85); backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(0,0,0,0.04);
  opacity: 0; transform: translateY(-12px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.top-nav--visible { opacity: 1; transform: translateY(0); }
.top-nav-brand {
  font-family: 'Ma Shan Zheng', cursive; font-size: 20px;
  letter-spacing: 8px; color: var(--ink-strong);
  cursor: pointer; user-select: none;
  transition: opacity 0.3s;
}
.top-nav-brand:hover { opacity: 0.7; }
.top-nav-links { display: flex; gap: 6px; }
.top-nav-item {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 11px; letter-spacing: 4px; color: var(--ink-faint);
  padding: 6px 16px; cursor: pointer;
  transition: all 0.3s ease; user-select: none;
  border: 1px solid transparent; border-radius: 2px;
}
.top-nav-item:hover { color: var(--ink-mid); border-color: var(--ink-ghost); }
.top-nav-item.active { color: var(--ink); border-color: var(--ink-faint); background: rgba(0,0,0,0.02); }

/* ===== HERO ===== */
.hero { position: relative; z-index: 2; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 40px 24px; }
.hero-bg-layer { position: absolute; inset: 0; background: radial-gradient(ellipse 60% 40% at 50% 20%, rgba(0,0,0,0.02) 0%, transparent 60%), radial-gradient(ellipse 50% 30% at 80% 70%, rgba(0,0,0,0.015) 0%, transparent 50%); }
.hero-inner { display: flex; flex-direction: column; align-items: center; gap: 40px; }
.hero-top { margin-bottom: -8px; }
.hero-badge { font-family: 'Noto Sans SC', sans-serif; font-size: 9px; letter-spacing: 8px; color: var(--ink-faint); font-weight: 300; }
.hero-main { display: flex; align-items: center; gap: 48px; will-change: transform, opacity; }

.seal-stamp { width: 64px; height: 64px; border: 2px solid var(--seal); color: var(--seal); display: flex; align-items: center; justify-content: center; font-family: 'Ma Shan Zheng', cursive; font-size: 16px; line-height: 1.3; letter-spacing: 2px; padding: 6px; flex-shrink: 0; position: relative; }
.seal-stamp::after { content: ''; position: absolute; inset: 3px; border: 1px solid var(--seal); opacity: 0.35; }

.vertical-text { writing-mode: vertical-rl; font-family: 'Noto Sans SC', sans-serif; font-size: 10px; letter-spacing: 8px; color: var(--ink-faint); font-weight: 300; flex-shrink: 0; }
.hero-center { text-align: center; }

.logo-crown { position: relative; display: inline-block; margin-bottom: 16px; }
.logo-crown img { width: 76px; height: 76px; display: block; position: relative; z-index: 1; }
.crown-ring { position: absolute; inset: -14px; border: 1px solid rgba(0,0,0,0.05); border-radius: 50%; animation: ring-spin 8s linear infinite; }
.crown-ring-2 { inset: -26px; animation-duration: 10s; animation-direction: reverse; }
.crown-ring-3 { inset: -38px; animation-duration: 14s; border-color: rgba(0,0,0,0.025); }
.crown-ring::before { content: ''; position: absolute; top: -2px; left: 50%; transform: translateX(-50%); width: 3px; height: 3px; border-radius: 50%; background: var(--ink-faint); }
@keyframes ring-spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

.hero h1 { font-family: 'Ma Shan Zheng', cursive; font-size: 84px; letter-spacing: 36px; color: var(--ink-strong); line-height: 1.1; text-shadow: 4px 4px 12px rgba(0,0,0,0.05); }
.hero-roman { font-family: 'Noto Sans SC', sans-serif; font-size: 10px; letter-spacing: 18px; color: var(--ink-faint); margin: 2px 0 18px; font-weight: 300; }
.hero-line { width: 36px; height: 1px; background: var(--ink-ghost); margin: 0 auto 18px; }

/* 打字机效果 */
.hero-quote { font-size: 13px; color: var(--ink-mid); letter-spacing: 6px; font-weight: 200; min-height: 1.6em; }
.type-char { opacity: 0; transition: opacity 0.15s ease; }
.type-char.visible { opacity: 1; }
.type-cursor { font-weight: 200; color: var(--ink-faint); margin-left: 2px; }
.type-cursor.blink { animation: cursor-blink 0.8s ease-in-out infinite; }
@keyframes cursor-blink { 0%, 100% { opacity: 1; } 50% { opacity: 0; } }

.scroll-hint { display: flex; flex-direction: column; align-items: center; gap: 10px; }
.scroll-track { width: 1px; height: 48px; background: var(--ink-ghost); position: relative; }
.scroll-progress { width: 100%; height: 50%; background: var(--ink-light); animation: scroll-move 2s ease-in-out infinite; }
@keyframes scroll-move { 0%, 100% { transform: translateY(-100%); } 50% { transform: translateY(100%); } }
.scroll-hint span { font-family: 'Noto Sans SC', sans-serif; font-size: 9px; letter-spacing: 6px; color: var(--ink-faint); font-weight: 300; }

/* ===== 反白段 ===== */
.dark-section { position: relative; z-index: 2; padding: 120px 24px; background: var(--ink-strong); overflow: hidden; }
.dark-bg-ink { position: absolute; inset: 0; background: radial-gradient(ellipse 80% 40% at 30% 50%, rgba(60,60,60,0.5) 0%, transparent 60%), radial-gradient(ellipse 60% 50% at 70% 30%, rgba(80,80,80,0.3) 0%, transparent 50%), radial-gradient(ellipse 40% 60% at 50% 80%, rgba(40,40,40,0.4) 0%, transparent 40%); }
.dark-content { position: relative; max-width: 720px; margin: 0 auto; }
.dark-frame { position: relative; border: 1px solid rgba(255,255,255,0.06); padding: 48px 40px; background: rgba(255,255,255,0.02); overflow: hidden; }
.dark-frame-ink {
  position: absolute; inset: -20px;
  background: radial-gradient(ellipse at 50% 50%, rgba(255,255,255,0.012) 0%, transparent 60%);
  animation: frame-ink-breathe 4s ease-in-out infinite alternate;
  pointer-events: none;
}
@keyframes frame-ink-breathe { 0% { transform: scale(1); opacity: 0.3; } 100% { transform: scale(1.15); opacity: 0.7; } }

.dark-corner { position: absolute; width: 24px; height: 24px; border-color: rgba(255,255,255,0.1); border-style: solid; }
.dark-corner.tl { top: 6px; left: 6px; border-width: 1px 0 0 1px; animation: corner-pulse 3s ease-in-out infinite; }
.dark-corner.tr { top: 6px; right: 6px; border-width: 1px 1px 0 0; animation: corner-pulse 3s ease-in-out 0.75s infinite; }
.dark-corner.bl { bottom: 6px; left: 6px; border-width: 0 0 1px 1px; animation: corner-pulse 3s ease-in-out 1.5s infinite; }
.dark-corner.br { bottom: 6px; right: 6px; border-width: 0 1px 1px 0; animation: corner-pulse 3s ease-in-out 2.25s infinite; }
@keyframes corner-pulse { 0%, 100% { border-color: rgba(255,255,255,0.1); } 50% { border-color: rgba(255,255,255,0.2); } }

.bagua-deco { display: flex; justify-content: center; gap: 16px; margin-bottom: 28px; }
.bagua-char { font-size: 14px; color: rgba(255,255,255,0.08); letter-spacing: 4px; }

.dark-grid { display: flex; gap: 36px; align-items: flex-start; }
.dark-seal { display: flex; flex-direction: column; align-items: center; gap: 10px; flex-shrink: 0; }
.dark-seal-inner { width: 56px; height: 56px; border: 2px solid rgba(184, 50, 42, 0.7); display: flex; align-items: center; justify-content: center; font-family: 'Ma Shan Zheng', cursive; font-size: 22px; color: rgba(184, 50, 42, 0.8); position: relative; }
.dark-seal-inner::after { content: ''; position: absolute; inset: 4px; border: 1px solid rgba(184, 50, 42, 0.3); }
.dark-seal span { font-family: 'Noto Sans SC', sans-serif; font-size: 8px; letter-spacing: 4px; color: rgba(255,255,255,0.25); }
.dark-text { flex: 1; }
.dark-line { color: rgba(255,255,255,0.55); font-size: 15px; line-height: 2.2; font-weight: 200; margin-bottom: 8px; }
.dark-em { color: rgba(255,255,255,0.85); font-weight: 700; }
.dark-divider { width: 40px; height: 1px; background: rgba(255,255,255,0.08); margin: 20px 0; }
.dark-tech { color: rgba(255,255,255,0.35); font-size: 13px; line-height: 2; font-weight: 200; }
.dark-tech strong { color: rgba(255,255,255,0.6); font-weight: 400; }

/* ===== 通用分区 ===== */
.scroll-section { position: relative; z-index: 2; padding: 100px 24px; display: flex; flex-direction: column; align-items: center; }
.section-label-wrap { display: flex; align-items: baseline; gap: 16px; margin-bottom: 56px; }
.section-number { font-family: 'Noto Sans SC', sans-serif; font-size: 10px; letter-spacing: 3px; color: var(--ink-faint); font-weight: 300; }
.section-title-cn { font-family: 'Noto Sans SC', sans-serif; font-size: 14px; letter-spacing: 10px; font-weight: 300; color: var(--ink-mid); }
.section-en { font-family: 'Noto Sans SC', sans-serif; font-size: 9px; letter-spacing: 4px; color: var(--ink-ghost); font-weight: 300; }

/* ===== 先贤之言 ===== */
.quotes-section { background: rgba(0,0,0,0.01); }
.quotes-timeline { max-width: 640px; width: 100%; position: relative; }
.quotes-timeline::before {
  content: ''; position: absolute; left: 20px; top: 0; bottom: 0;
  width: 1px; background: var(--ink-ghost); opacity: 0.3;
}
.quote-item {
  display: flex; gap: 20px; align-items: flex-start;
  padding: 20px 0; position: relative;
}
.quote-line-connector {
  position: absolute; left: 17px; top: 32px;
  width: 7px; height: 1px; background: var(--ink-ghost); opacity: 0.3;
}
.quote-char {
  width: 40px; height: 40px; flex-shrink: 0;
  display: flex; align-items: center; justify-content: center;
  font-family: 'Ma Shan Zheng', cursive; font-size: 18px;
  color: var(--ink-faint); border: 1px solid var(--ink-ghost);
  background: var(--paper); position: relative; z-index: 1;
}
.quote-content { flex: 1; padding-top: 6px; }
.quote-text { font-size: 14px; color: var(--ink-mid); line-height: 1.9; font-weight: 200; letter-spacing: 2px; }
.quote-attrib { margin-top: 6px; display: flex; gap: 6px; align-items: center; }
.quote-source { font-family: 'Noto Sans SC', sans-serif; font-size: 9px; color: var(--ink-faint); letter-spacing: 2px; }
.quote-sep { font-size: 8px; color: var(--ink-ghost); }
.quote-chapter { font-family: 'Noto Sans SC', sans-serif; font-size: 9px; color: var(--ink-ghost); letter-spacing: 1px; }

/* ===== 能力卡片 ===== */
.features-grid {
  display: grid; grid-template-columns: repeat(4, 1fr);
  gap: 12px; max-width: 880px; width: 100%;
}
.feature-card {
  position: relative; padding: 24px 16px 20px;
  background: rgba(255,255,255,0.15); backdrop-filter: blur(8px);
  border: 1px solid rgba(0,0,0,0.04);
  text-align: center; overflow: hidden;
  transition: all 0.5s cubic-bezier(0.22,1,0.36,1);
}
.feature-card:hover {
  background: rgba(255,255,255,0.35);
  transform: translateY(-6px);
  border-color: rgba(0,0,0,0.06);
}
.feature-card:hover .feature-ink { opacity: 0.6; }
.feature-card:hover .feature-ink-hover { opacity: 1; }
.feature-icon { font-size: 24px; margin-bottom: 10px; opacity: 0.3; }
.feature-title { font-family: 'Noto Sans SC', sans-serif; font-size: 12px; letter-spacing: 4px; font-weight: 400; color: var(--ink-mid); margin-bottom: 8px; }
.feature-desc { font-size: 11px; color: var(--ink-light); line-height: 1.8; font-weight: 200; }
.feature-ink {
  position: absolute; bottom: 0; left: 0; width: 100%; height: 2px;
  background: linear-gradient(90deg, transparent, var(--ink-faint), transparent);
  opacity: 0; transition: opacity 0.6s ease;
}
.feature-ink-hover {
  position: absolute; inset: 0;
  background: radial-gradient(ellipse 60% 30% at 50% 100%, rgba(0,0,0,0.03) 0%, transparent 60%);
  opacity: 0; transition: opacity 0.6s ease; pointer-events: none;
}

/* ===== 世代 ===== */
.gen-scroll-container { display: flex; align-items: stretch; gap: 0; max-width: 880px; width: 100%; padding: 0 16px; }
.gen-card-wrap { flex: 1; display: flex; align-items: center; }
.gen-card { flex: 1; padding: 28px 12px 20px; text-align: center; background: rgba(255,255,255,0.2); backdrop-filter: blur(8px); border: 1px solid rgba(0,0,0,0.04); transition: all 0.5s ease; position: relative; transform: perspective(600px) rotateX(var(--hover-y, 0deg)) rotateY(var(--hover-x, 0deg)) translateY(calc(var(--hover-y, 0px) * -0.5)); }
.gen-card:hover { background: rgba(255,255,255,0.4); border-color: rgba(0,0,0,0.06); box-shadow: 0 8px 24px rgba(0,0,0,0.03); }
.gen-card::before { content: ''; position: absolute; top: 0; left: 15%; width: 70%; height: 2px; background: linear-gradient(90deg, transparent, var(--ink-faint), transparent); opacity: 0.12; }
.gen-yao { font-size: 11px; color: var(--ink-ghost); letter-spacing: 4px; margin-bottom: 4px; opacity: 0.3; font-weight: 300; }
.gen-trigram { font-size: 22px; color: var(--ink-faint); margin-bottom: 8px; opacity: 0.35; }
.gen-num { font-family: 'Noto Sans SC', sans-serif; font-size: 9px; letter-spacing: 3px; color: var(--ink-faint); margin-bottom: 6px; font-weight: 300; }
.gen-name { font-family: 'Ma Shan Zheng', cursive; font-size: 28px; color: var(--ink-strong); margin-bottom: 4px; }
.gen-phrase { font-size: 11px; color: var(--ink-light); letter-spacing: 2px; margin-bottom: 10px; font-weight: 300; }
.gen-dash { width: 20px; height: 1px; background: var(--ink-ghost); margin: 0 auto 10px; }
.gen-desc { font-size: 11px; color: var(--ink-light); line-height: 1.7; font-weight: 300; }
.gen-arrow { flex: 0 0 20px; display: flex; align-items: center; justify-content: center; opacity: 0.4; }

.gen-quote { display: flex; align-items: center; gap: 16px; margin-top: 48px; }
.gen-quote p { font-size: 12px; color: var(--ink-faint); letter-spacing: 6px; font-weight: 300; white-space: nowrap; }
.gen-quote-line { width: 48px; height: 1px; background: var(--ink-ghost); }

/* ===== 品阶 ===== */
.tier-universe { position: relative; width: 400px; height: 200px; margin-bottom: 36px; }
.tier-orbit-svg { position: absolute; inset: 0; width: 100%; height: 100%; }
.tier-orb { position: absolute; top: 50%; left: 50%; width: 52px; height: 52px; animation: orb-rotate 12s linear infinite; animation-delay: var(--delay,0s); }
.tier-orb:hover { animation-play-state: paused; }
@keyframes orb-rotate { 0% { transform: translate(-50%,-50%) rotate(var(--angle,0deg)) translateX(var(--rx,100px)); } 100% { transform: translate(-50%,-50%) rotate(calc(var(--angle,0deg) + 360deg)) translateX(var(--rx,100px)); } }
.orb-inner { width: 52px; height: 52px; border-radius: 50%; border: 1px solid rgba(0,0,0,0.08); display: flex; flex-direction: column; align-items: center; justify-content: center; background: rgba(255,255,255,0.3); backdrop-filter: blur(6px); transition: all 0.4s ease; position: relative; z-index: 1; }
.tier-orb.active .orb-inner { border-color: var(--ink); background: rgba(255,255,255,0.5); }
.orb-inner:hover { transform: scale(1.1); border-color: rgba(0,0,0,0.15); }
.orb-char { font-family: 'Ma Shan Zheng', cursive; font-size: 20px; color: var(--ink-strong); line-height: 1; }
.orb-label { font-family: 'Noto Sans SC', sans-serif; font-size: 8px; color: var(--ink-faint); letter-spacing: 2px; margin-top: 1px; }
.orb-glow { position: absolute; inset: -4px; border-radius: 50%; background: radial-gradient(circle, rgba(0,0,0,0.04) 0%, transparent 70%); opacity: 0; transition: opacity 0.4s; pointer-events: none; }
.tier-orb:hover .orb-glow, .tier-orb.active .orb-glow { opacity: 1; animation: glow-breathe 2s ease-in-out infinite alternate; }
@keyframes glow-breathe { 0% { transform: scale(0.9); opacity: 0.2; } 100% { transform: scale(1.3); opacity: 0.5; } }

.tier-legend { display: flex; gap: 12px; flex-wrap: wrap; justify-content: center; max-width: 600px; }
.legend-item { display: flex; align-items: center; gap: 4px; }
.legend-char { font-family: 'Ma Shan Zheng', cursive; font-size: 16px; color: var(--ink-light); }
.legend-meaning { font-family: 'Noto Sans SC', sans-serif; font-size: 10px; color: var(--ink-faint); letter-spacing: 1px; }
.legend-sep { color: var(--ink-ghost); font-size: 8px; }

.tier-example { margin-top: 32px; display: flex; flex-direction: column; align-items: center; gap: 10px; }
.tier-example-label { font-family: 'Noto Sans SC', sans-serif; font-size: 9px; color: var(--ink-faint); letter-spacing: 4px; }
.tier-example-group { display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
.example-tag { font-family: 'Noto Sans SC', sans-serif; font-size: 10px; color: var(--ink-light); padding: 4px 12px; border: 1px solid var(--ink-ghost); letter-spacing: 2px; transition: all 0.3s; }
.example-tag:hover { border-color: var(--ink-faint); color: var(--ink-mid); background: rgba(255,255,255,0.2); }

/* ===== FOOTER ===== */
footer { position: relative; z-index: 2; padding: 0 24px 40px; text-align: center; }
.footer-wave { width: 100%; height: 40px; margin-bottom: 32px; }
.footer-wave svg { width: 100%; height: 100%; display: block; }
.footer-inner { display: flex; flex-direction: column; align-items: center; gap: 14px; }
.footer-hex { font-size: 24px; color: var(--ink-ghost); opacity: 0.3; }
.footer-brand { font-family: 'Ma Shan Zheng', cursive; font-size: 20px; letter-spacing: 10px; color: var(--ink-faint); }
.footer-divider { width: 40px; height: 1px; background: var(--ink-ghost); }
.footer-tagline { font-family: 'Noto Sans SC', sans-serif; font-size: 9px; color: var(--ink-faint); letter-spacing: 6px; font-weight: 200; }
.footer-info { font-family: 'Noto Sans SC', sans-serif; font-size: 10px; color: var(--ink-ghost); letter-spacing: 4px; font-weight: 300; display: flex; gap: 8px; }
.footer-dot { color: var(--ink-ghost); }
.footer-links { display: flex; gap: 10px; align-items: center; }
.footer-link { font-family: 'Noto Sans SC', sans-serif; font-size: 10px; color: var(--ink-light); text-decoration: none; letter-spacing: 5px; transition: color 0.3s; font-weight: 300; }
.footer-link:hover { color: var(--ink-strong); }

/* ===== 聊天页 ===== */
.chat-page {
  position: relative; z-index: 2; min-height: 100vh;
  display: flex; flex-direction: column;
  padding: 72px 24px 40px; overflow: hidden;
  cursor: auto;
}
.chat-bg-ink {
  position: fixed; inset: 0; width: 100%; height: 100%;
  pointer-events: none; z-index: 0; opacity: 0.6;
}
.chat-bg-ink--bottom {
  top: auto; bottom: 0; height: 40vh;
}

/* 页首 */
.chat-page-top {
  position: relative; z-index: 1;
  display: flex; align-items: center; gap: 20px;
  padding: 0 4px; margin-bottom: 28px; margin-top: 8px;
}
.chat-seal {
  flex-shrink: 0; width: 48px; height: 48px;
  display: flex; align-items: center; justify-content: center;
  font-family: 'Ma Shan Zheng', cursive; font-size: 20px;
  color: var(--seal); border: 2px solid var(--seal);
  position: relative; background: rgba(184,50,42,0.04);
}
.chat-seal::after {
  content: ''; position: absolute; inset: 3px;
  border: 1px solid var(--seal); opacity: 0.25;
}
.chat-page-title-group { flex: 1; }
.chat-page-title {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 18px; letter-spacing: 8px; font-weight: 300;
  color: var(--ink-mid); margin-bottom: 2px;
}
.chat-page-subtitle {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 9px; letter-spacing: 12px; color: var(--ink-faint); font-weight: 300;
}
.chat-hex-deco { display: flex; gap: 8px; opacity: 0.08; }
.chat-hex-deco span { font-size: 18px; }

/* 聊天框 */
.chat-box {
  position: relative; z-index: 1;
  width: 100%; max-width: 680px; margin: 0 auto;
  background: rgba(255,255,255,0.3); backdrop-filter: blur(16px);
  border: 1px solid rgba(0,0,0,0.04);
  display: flex; flex-direction: column;
  min-height: 460px; flex: 1;
  box-shadow: 0 1px 12px rgba(0,0,0,0.02), 0 4px 32px rgba(0,0,0,0.01);
}
.chat-box-rule { height: 12px; flex-shrink: 0; }
.chat-box-rule svg { width: 100%; height: 100%; display: block; }

/* 消息列表 */
.chat-messages {
  flex: 1; padding: 16px 20px; overflow-y: auto;
  display: flex; flex-direction: column; gap: 14px;
  min-height: 240px; max-height: 520px;
}

/* 空状态 */
.chat-empty {
  display: flex; flex-direction: column; align-items: center;
  justify-content: center; height: 100%; min-height: 280px;
  gap: 14px; user-select: none;
}
.chat-empty-ornament { position: relative; width: 48px; height: 48px; display: flex; align-items: center; justify-content: center; margin-bottom: 4px; }
.empty-taiji { font-size: 28px; opacity: 0.08; position: relative; z-index: 1; }
.empty-ring { position: absolute; inset: -6px; border: 1px solid rgba(0,0,0,0.04); border-radius: 50%; animation: empty-ring-pulse 3s ease-in-out infinite; }
.empty-ring-2 { inset: -14px; animation-delay: 0.8s; }
@keyframes empty-ring-pulse { 0%, 100% { transform: scale(1); opacity: 0.3; } 50% { transform: scale(1.08); opacity: 0.6; } }
.empty-line-1 {
  font-family: 'Ma Shan Zheng', cursive;
  font-size: 22px; color: var(--ink-faint); letter-spacing: 12px;
}
.empty-line-2 {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 10px; color: var(--ink-ghost); letter-spacing: 4px;
}
.empty-brush { margin-top: 4px; opacity: 0.4; }

/* 消息气泡 */
.chat-msg { display: flex; gap: 10px; align-items: flex-start; animation: msg-in 0.35s ease; }
@keyframes msg-in { 0% { opacity: 0; transform: translateY(10px); } 100% { opacity: 1; transform: translateY(0); } }
.chat-msg--user { flex-direction: row-reverse; }

.chat-avatar { flex-shrink: 0; width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; }
.chat-avatar-text {
  font-family: 'Ma Shan Zheng', cursive; font-size: 15px;
  width: 34px; height: 34px; line-height: 34px; text-align: center;
  transition: all 0.3s;
}
.chat-avatar--user .chat-avatar-text {
  background: var(--ink); color: var(--paper); border-radius: 50%;
  font-size: 13px;
}
.chat-avatar--ai .chat-avatar-text {
  border: 1px solid var(--ink-faint); color: var(--ink-mid);
  border-radius: 50%; font-size: 13px;
  background: rgba(255,255,255,0.5);
}

.chat-bubble {
  max-width: 72%; padding: 10px 14px;
  font-size: 13px; line-height: 1.8; letter-spacing: 0.5px;
  font-weight: 200; position: relative;
  transition: all 0.3s;
}
.chat-bubble--user {
  background: var(--ink); color: var(--paper);
  border-radius: 3px 3px 1px 3px;
}
.chat-bubble--ai {
  background: rgba(0,0,0,0.02); color: var(--ink-mid);
  border: 1px solid rgba(0,0,0,0.04);
  border-radius: 3px 3px 3px 1px;
}
.chat-bubble--typing { min-width: 48px; }

.chat-typing { display: inline-flex; gap: 4px; align-items: center; padding: 2px 0; }
.chat-dot {
  width: 5px; height: 5px; border-radius: 50%;
  background: var(--ink-faint);
  animation: chat-dot-bounce 1.2s ease-in-out infinite;
}
@keyframes chat-dot-bounce { 0%, 80%, 100% { transform: translateY(0); } 40% { transform: translateY(-6px); } }

/* 输入区 */
.chat-input-area { padding: 0 16px 14px; flex-shrink: 0; }
.chat-input-rule { height: 8px; margin-bottom: 12px; }
.chat-input-rule svg { width: 100%; height: 100%; display: block; }
.chat-input-wrap { display: flex; gap: 8px; align-items: flex-end; }
.chat-input {
  flex: 1; resize: none; outline: none;
  font-family: 'Noto Serif SC', serif;
  font-size: 13px; line-height: 1.6; padding: 8px 12px;
  background: rgba(255,255,255,0.5);
  border: 1px solid rgba(0,0,0,0.06);
  color: var(--ink); letter-spacing: 0.5px; font-weight: 200;
  transition: border-color 0.3s; border-radius: 2px;
  min-height: 40px; max-height: 120px;
}
.chat-input:focus { border-color: var(--ink-faint); }
.chat-input::placeholder { color: var(--ink-ghost); font-weight: 200; font-size: 12px; }
.chat-input:disabled { opacity: 0.35; }
.chat-send-btn {
  flex-shrink: 0; width: 40px; height: 40px;
  display: flex; align-items: center; justify-content: center;
  font-family: 'Ma Shan Zheng', cursive; font-size: 18px;
  background: var(--ink); color: var(--paper);
  border: none; cursor: pointer;
  transition: all 0.35s ease; border-radius: 2px;
  position: relative; overflow: hidden;
}
.chat-send-btn::after {
  content: ''; position: absolute; inset: 3px;
  border: 1px solid rgba(255,255,255,0.08);
  transition: all 0.3s;
}
.chat-send-btn:hover:not(:disabled) { background: var(--ink-strong); }
.chat-send-btn:hover:not(:disabled)::after { border-color: rgba(255,255,255,0.15); }
.chat-send-btn:disabled { opacity: 0.15; cursor: default; }
.chat-input-hint {
  font-family: 'Noto Sans SC', sans-serif;
  font-size: 8px; color: var(--ink-ghost);
  letter-spacing: 2px; margin-top: 7px; text-align: center;
}

/* ===== 滚动揭示 ===== */
.reveal { opacity: 0; transform: translateY(28px); transition: opacity 0.9s cubic-bezier(0.22,1,0.36,1), transform 0.9s cubic-bezier(0.22,1,0.36,1); }
.reveal.show { opacity: 1; transform: translateY(0); }

/* ===== 响应式 ===== */
@media (max-width: 768px) {
  .ink-nav { right: 10px; gap: 14px; }
  .ink-nav-label { display: none; }
  .ink-nav-item.active .ink-nav-dot { width: 6px; height: 6px; }
  .hero h1 { font-size: 52px; letter-spacing: 24px; }
  .hero-main { gap: 20px; }
  .seal-stamp { width: 48px; height: 48px; font-size: 13px; }
  .vertical-text { display: none; }
  .dark-grid { flex-direction: column; align-items: center; }
  .dark-frame { padding: 32px 20px; }
  .features-grid { grid-template-columns: repeat(2, 1fr); }
  .gen-scroll-container { flex-wrap: wrap; }
  .gen-card-wrap { flex: 0 0 45%; margin-bottom: 16px; }
  .gen-arrow { display: none; }
  .tier-universe { width: 300px; height: 160px; transform: scale(0.85); }
  .gen-quote p { font-size: 10px; letter-spacing: 4px; }
  .bagua-deco { gap: 10px; }
  .load-reveal-text { font-size: 48px; letter-spacing: 24px; }
  .quote-text { font-size: 13px; }
  .hero-quote { font-size: 12px; letter-spacing: 4px; }
  .chat-messages { max-height: 360px; min-height: 200px; }
  .chat-bubble { max-width: 85%; font-size: 12px; }
}

@media (max-width: 400px) {
  .hero h1 { font-size: 38px; letter-spacing: 16px; }
  .seal-stamp { display: none; }
  .hero-quote { font-size: 10px; letter-spacing: 3px; }
  .features-grid { grid-template-columns: 1fr; }
  .gen-card-wrap { flex: 0 0 100%; }
  .gen-name { font-size: 24px; }
  .gen-quote { flex-direction: column; gap: 8px; }
  .tier-example-group { flex-direction: column; align-items: center; }
  .load-reveal-text { font-size: 32px; letter-spacing: 16px; }
  .quote-item { gap: 12px; }
  .quote-char { width: 32px; height: 32px; font-size: 14px; }
  .footer-links { flex-wrap: wrap; justify-content: center; }
  .chat-box { min-height: 320px; }
  .chat-messages { max-height: 280px; min-height: 160px; padding: 12px; }
  .chat-bubble { max-width: 90%; padding: 8px 10px; }
  .chat-input-area { padding: 8px 10px 12px; }
}
</style>
