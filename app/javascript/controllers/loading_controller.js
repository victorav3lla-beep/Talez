import { Controller } from "@hotwired/stimulus"

let loadingStartedAt = null
const MIN_DISPLAY_MS = 1200      // show overlay at least this long
const MAX_WAIT_MS    = 25000     // force-hide after this long even if slow

export default class extends Controller {
  static targets = ["starsContainer", "bookCatcher", "score"]

  connect() {
    setTimeout(() => this.initializeGame(), 100)
  }

  initializeGame() {
    this.scoreValue = 0
    this.bookX = window.innerWidth / 2 - 58
    this.isDragging = false
    this.initialX = 0
    this.createStars()
    this.setupDragging()
    this.setupArrowKeys()
    this.startFallingStars()
    this.createAudioContext()
  }

  createAudioContext() {
    this.audioContext = new (window.AudioContext || window.webkitAudioContext)()
  }

  playDingSound() {
    if (!this.audioContext) return
    const now = this.audioContext.currentTime
    const osc = this.audioContext.createOscillator()
    const gain = this.audioContext.createGain()
    osc.connect(gain)
    gain.connect(this.audioContext.destination)
    osc.frequency.value = 800
    gain.gain.setValueAtTime(0.3, now)
    gain.gain.exponentialRampToValueAtTime(0.01, now + 0.2)
    osc.start(now)
    osc.stop(now + 0.2)
  }

  createStars() {
    for (let i = 0; i < 50; i++) {
      const star = document.createElement("div")
      star.className = "bg-star"
      star.style.left = Math.random() * 100 + "%"
      star.style.top = Math.random() * 100 + "%"
      star.style.animationDelay = Math.random() * 3 + "s"
      this.starsContainerTarget.appendChild(star)
    }
  }

  setupDragging() {
    const book = this.bookCatcherTarget
    book.style.position = "absolute"
    book.style.left = this.bookX + "px"
    book.style.cursor = "grab"

    const downMouse = (e) => { this.isDragging = true; this.initialX = e.clientX - this.bookX; book.style.cursor = "grabbing" }
    const downTouch = (e) => { this.isDragging = true; this.initialX = e.touches[0].clientX - this.bookX }
    const moveMouse = (e) => {
      if (!this.isDragging) return
      this.bookX = e.clientX - this.initialX
      const maxX = window.innerWidth - 116
      this.bookX = Math.max(0, Math.min(this.bookX, maxX))
      book.style.left = this.bookX + "px"
    }
    const moveTouch = (e) => {
      if (!this.isDragging) return
      e.preventDefault()
      this.bookX = e.touches[0].clientX - this.initialX
      const maxX = window.innerWidth - 116
      this.bookX = Math.max(0, Math.min(this.bookX, maxX))
      book.style.left = this.bookX + "px"
    }
    const endAll = () => { this.isDragging = false; book.style.cursor = "grab" }

    book.addEventListener("mousedown", downMouse)
    book.addEventListener("touchstart", downTouch, { passive: false })
    document.addEventListener("mousemove", moveMouse)
    document.addEventListener("touchmove", moveTouch, { passive: false })
    document.addEventListener("mouseup", endAll)
    document.addEventListener("touchend", endAll)
  }

  setupArrowKeys() {
    const book = this.bookCatcherTarget
    document.addEventListener("keydown", (e) => {
      const step = 30
      const maxX = window.innerWidth - 116
      if (e.key === "ArrowLeft") {
        this.bookX = Math.max(0, this.bookX - step)
        book.style.left = this.bookX + "px"
      } else if (e.key === "ArrowRight") {
        this.bookX = Math.min(maxX, this.bookX + step)
        book.style.left = this.bookX + "px"
      }
    })
  }

  createFallingStar() {
    const star = document.createElement("div")
    star.className = "falling-star"
    star.textContent = "⭐"
    star.style.left = Math.random() * (window.innerWidth - 50) + "px"
    const duration = 6 + Math.random() * 3
    star.style.animationDuration = duration + "s"
    this.element.appendChild(star)

    const checkCollision = setInterval(() => {
      if (!star.parentNode) { clearInterval(checkCollision); return }
      const s = star.getBoundingClientRect()
      const b = this.bookCatcherTarget.getBoundingClientRect()
      if (s.left < b.right && s.right > b.left && s.bottom > b.top + 20 && s.top < b.bottom) {
        this.scoreValue++
        this.scoreTarget.textContent = this.scoreValue
        this.playDingSound()
        star.remove()
        clearInterval(checkCollision)
      }
    }, 30)

    setTimeout(() => { if (star.parentNode) star.remove(); clearInterval(checkCollision) }, duration * 1000)
  }

  startFallingStars() {
    this.starInterval = setInterval(() => this.createFallingStar(), 800)
  }
}

// Show overlay when form submits
document.addEventListener("turbo:submit-start", () => {
  loadingStartedAt = Date.now()
  const overlay = document.getElementById("loadingOverlay")
  if (overlay) overlay.style.display = "block"
})

// Hide overlay after min time, when images load, or after max wait
document.addEventListener("turbo:load", () => {
  const overlay = document.getElementById("loadingOverlay")
  if (!overlay) return

  const elapsed = loadingStartedAt ? Date.now() - loadingStartedAt : 0
  const waitMin = Math.max(0, MIN_DISPLAY_MS - elapsed)

  const hide = () => { overlay.style.display = "none" }

  setTimeout(() => {
    const images = document.querySelectorAll("img[src]")
    if (images.length === 0) {
      hide()
      return
    }

    let loaded = 0
    const check = () => { if (loaded === images.length) hide() }
    images.forEach((img) => {
      if (img.complete) {
        loaded++
      } else {
        img.onload = () => { loaded++; check() }
        img.onerror = () => { loaded++; check() }
      }
    })
    check()

    // Force-hide if still not done after MAX_WAIT_MS
    setTimeout(hide, MAX_WAIT_MS)
  }, waitMin)
})
