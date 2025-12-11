import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  connect() {
    this.resetTilt()
    this.addEffectLayers()
    this.hoverInterval = null
    this.ambientInterval = null
    this.isHovering = false

    // Auto-start ambient sparkles for "Create Your Own" card
    if (this.cardTarget.classList.contains('create-own-card')) {
      this.isCreateCard = true
      this.startAmbientSparkles()
    } else {
      this.isCreateCard = false
    }
  }

  disconnect() {
    if (this.hoverInterval) clearInterval(this.hoverInterval)
    if (this.ambientInterval) clearInterval(this.ambientInterval)
  }

  addEffectLayers() {
    // Rainbow holographic layer
    if (!this.cardTarget.querySelector('.holo-rainbow')) {
      const rainbow = document.createElement('div')
      rainbow.className = 'holo-rainbow'
      this.cardTarget.appendChild(rainbow)
    }

    // Sparkle container
    if (!this.cardTarget.querySelector('.sparkle-container')) {
      const sparkles = document.createElement('div')
      sparkles.className = 'sparkle-container'
      this.cardTarget.appendChild(sparkles)
    }
  }

  move(event) {
    const card = this.cardTarget
    const rect = card.getBoundingClientRect()

    const x = event.clientX - rect.left
    const y = event.clientY - rect.top
    const centerX = rect.width / 2
    const centerY = rect.height / 2

    // Rotation (Max 12 deg)
    const rotateX = ((y - centerY) / centerY) * -12
    const rotateY = ((x - centerX) / centerX) * 12

    // Calculate intensity and angle
    const intensity = Math.min(Math.sqrt(rotateX * rotateX + rotateY * rotateY) / 12, 1)
    const angle = Math.atan2(rotateX, rotateY) * (180 / Math.PI)

    // Apply 3D tilt with dynamic shadow
    const shadowX = rotateY * 2
    const shadowY = -rotateX * 2
    const shadowBlur = 20 + (intensity * 20)
    card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(1.05)`
    card.style.boxShadow = `${shadowX}px ${shadowY}px ${shadowBlur}px rgba(0, 0, 0, ${0.3 + intensity * 0.2})`

    // Parallax depth - image moves slower
    const img = card.querySelector('.character-image-wrapper')
    if (img) {
      img.style.transform = `translateX(${rotateY * 0.5}px) translateY(${-rotateX * 0.5}px)`
    }

    // Rainbow holographic layer
    const rainbow = card.querySelector('.holo-rainbow')
    if (rainbow) {
      const hueShift = angle + 180
      rainbow.style.background = `
        linear-gradient(${angle + 90}deg,
          hsla(${hueShift}, 100%, 70%, ${0.3 * intensity}),
          hsla(${hueShift + 60}, 100%, 70%, ${0.2 * intensity}),
          hsla(${hueShift + 120}, 100%, 70%, ${0.3 * intensity}),
          transparent
        )`
      rainbow.style.opacity = '1'
    }

    // Hover sparkles - separate from ambient
    if (intensity > 0.4 && !this.hoverInterval) {
      this.startHoverSparkles()
    } else if (intensity <= 0.2 && this.hoverInterval) {
      this.stopHoverSparkles()
    }
  }

  // Fast sparkles on hover (all cards)
  startHoverSparkles() {
    const container = this.cardTarget.querySelector('.sparkle-container')
    if (!container) return

    this.hoverInterval = setInterval(() => {
      const sparkle = document.createElement('div')
      sparkle.className = 'sparkle sparkle-hover'
      sparkle.style.left = Math.random() * 100 + '%'
      sparkle.style.top = Math.random() * 100 + '%'
      sparkle.style.animationDelay = Math.random() * 0.3 + 's'
      container.appendChild(sparkle)

      setTimeout(() => sparkle.remove(), 1000)
    }, 150)
  }

  stopHoverSparkles() {
    if (this.hoverInterval) {
      clearInterval(this.hoverInterval)
      this.hoverInterval = null
    }
  }

  // Ambient sparkles for "Create Your Own" card - magical, slow effect
  startAmbientSparkles() {
    const container = this.cardTarget.querySelector('.sparkle-container')
    if (!container) return

    // Teal color palette (#4ECDC4) with variations
    const colors = [
      { bg: 'rgba(78, 205, 196, 0.95)', glow: 'rgba(78, 205, 196, 0.7)' },     // Teal
      { bg: 'rgba(100, 220, 210, 0.9)', glow: 'rgba(100, 220, 210, 0.6)' },    // Light teal
      { bg: 'rgba(60, 180, 172, 0.9)', glow: 'rgba(60, 180, 172, 0.6)' },      // Dark teal
      { bg: 'rgba(255, 255, 255, 0.9)', glow: 'rgba(255, 255, 255, 0.7)' },    // White accent
    ]

    const createAmbientSparkle = () => {
      const sparkle = document.createElement('div')
      sparkle.className = 'sparkle sparkle-ambient'

      // Random position with slight bias towards center
      const randomWithBias = () => 15 + Math.random() * 70
      sparkle.style.left = randomWithBias() + '%'
      sparkle.style.top = randomWithBias() + '%'

      // Smaller sizes
      const size = 2 + Math.random() * 3
      sparkle.style.width = size + 'px'
      sparkle.style.height = size + 'px'

      // Random color with glow
      const colorSet = colors[Math.floor(Math.random() * colors.length)]
      sparkle.style.background = colorSet.bg
      sparkle.style.boxShadow = `
        0 0 ${size}px ${colorSet.glow},
        0 0 ${size * 2}px ${colorSet.glow}
      `

      // Varied animation duration for organic feel
      const duration = 2 + Math.random() * 2
      sparkle.style.animationDuration = duration + 's'

      // Random delay for staggered effect
      sparkle.style.animationDelay = Math.random() * 0.5 + 's'

      container.appendChild(sparkle)
      setTimeout(() => sparkle.remove(), (duration + 0.5) * 1000)
    }

    // Create a burst of initial sparkles
    for (let i = 0; i < 5; i++) {
      setTimeout(() => createAmbientSparkle(), i * 150)
    }

    // Continuous ambient sparkles at slower pace
    this.ambientInterval = setInterval(createAmbientSparkle, 500)
  }

  stopAmbientSparkles() {
    if (this.ambientInterval) {
      clearInterval(this.ambientInterval)
      this.ambientInterval = null
    }
  }

  leave() {
    this.resetTilt()
    this.stopHoverSparkles()

    const rainbow = this.cardTarget.querySelector('.holo-rainbow')
    const img = this.cardTarget.querySelector('.character-image-wrapper')

    if (rainbow) rainbow.style.opacity = '0'
    if (img) img.style.transform = 'translateX(0) translateY(0)'

    // Clear hover sparkles only (keep ambient for create card)
    const hoverSparkles = this.cardTarget.querySelectorAll('.sparkle-hover')
    hoverSparkles.forEach(s => s.remove())
  }

  resetTilt() {
    this.cardTarget.style.transform = `perspective(1000px) rotateX(0) rotateY(0) scale(1)`
    this.cardTarget.style.boxShadow = '0 10px 30px rgba(0, 0, 0, 0.1)'
  }
}
