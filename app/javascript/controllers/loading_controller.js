import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["starsContainer", "bookCatcher", "score"]

  connect() {
    console.log("Loading controller connected")
    // Small delay to ensure DOM is ready
    setTimeout(() => this.initializeGame(), 100)
  }

  initializeGame() {
    console.log("Initializing game...")
    this.scoreValue = 0
    this.bookX = window.innerWidth / 2 - 58 // Half of 116px width
    this.isDragging = false
    this.initialX = 0

    this.createStars()
    this.setupDragging()
    this.setupArrowKeys()
    this.startFallingStars()
    this.createAudioContext()

    console.log("Game initialized, bookX:", this.bookX)
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
    console.log("Setting up dragging for book:", book)

    book.style.position = "absolute"
    book.style.left = this.bookX + "px"
    book.style.cursor = "grab"

    const handleMouseDown = (e) => {
      console.log("Mouse down on book")
      this.isDragging = true
      this.initialX = e.clientX - this.bookX
      book.style.cursor = "grabbing"
    }

    const handleTouchStart = (e) => {
      console.log("Touch start on book")
      this.isDragging = true
      this.initialX = e.touches[0].clientX - this.bookX
    }

    const handleMouseMove = (e) => {
      if (!this.isDragging) return
      this.bookX = e.clientX - this.initialX
      const maxX = window.innerWidth - 116 // Use actual width
      this.bookX = Math.max(0, Math.min(this.bookX, maxX))
      book.style.left = this.bookX + "px"
    }

    const handleTouchMove = (e) => {
      if (!this.isDragging) return
      e.preventDefault()
      this.bookX = e.touches[0].clientX - this.initialX
      const maxX = window.innerWidth - 116
      this.bookX = Math.max(0, Math.min(this.bookX, maxX))
      book.style.left = this.bookX + "px"
    }

    const handleEnd = () => {
      this.isDragging = false
      book.style.cursor = "grab"
    }

    book.addEventListener("mousedown", handleMouseDown)
    book.addEventListener("touchstart", handleTouchStart, { passive: false })
    document.addEventListener("mousemove", handleMouseMove)
    document.addEventListener("touchmove", handleTouchMove, { passive: false })
    document.addEventListener("mouseup", handleEnd)
    document.addEventListener("touchend", handleEnd)

    console.log("Drag listeners attached")
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
      if (!star.parentNode) {
        clearInterval(checkCollision)
        return
      }

      const starRect = star.getBoundingClientRect()
      const bookRect = this.bookCatcherTarget.getBoundingClientRect()

      // Book is 116px wide x 125px tall, only trigger when star is really touching
      if (
        starRect.left < bookRect.right &&
        starRect.right > bookRect.left &&
        starRect.bottom > bookRect.top + 20 &&
        starRect.top < bookRect.bottom
      ) {
        this.scoreValue++
        this.scoreTarget.textContent = this.scoreValue
        this.playDingSound()
        star.remove()
        clearInterval(checkCollision)
      }
    }, 30)

    setTimeout(() => {
      if (star.parentNode) {
        star.remove()
      }
      clearInterval(checkCollision)
    }, duration * 1000)
  }

  startFallingStars() {
    this.starInterval = setInterval(() => {
      this.createFallingStar()
    }, 800)
  }
}

document.addEventListener("turbo:submit-start", () => {
  document.getElementById("loadingOverlay").style.display = "block"
})

document.addEventListener("turbo:load", () => {
  document.getElementById("loadingOverlay").style.display = "none"
})
