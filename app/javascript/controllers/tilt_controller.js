import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  connect() {
    this.resetTilt()
    this.addEffectLayers()
    this.sparkleInterval = null
  }

  disconnect() {
    if (this.sparkleInterval) clearInterval(this.sparkleInterval)
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

    // Sparkles - add on movement
    if (intensity > 0.4 && !this.sparkleInterval) {
      this.startSparkles()
    } else if (intensity <= 0.2 && this.sparkleInterval) {
      this.stopSparkles()
    }
  }

  startSparkles() {
    const container = this.cardTarget.querySelector('.sparkle-container')
    if (!container) return

    this.sparkleInterval = setInterval(() => {
      const sparkle = document.createElement('div')
      sparkle.className = 'sparkle'
      sparkle.style.left = Math.random() * 100 + '%'
      sparkle.style.top = Math.random() * 100 + '%'
      sparkle.style.animationDelay = Math.random() * 0.5 + 's'
      container.appendChild(sparkle)

      setTimeout(() => sparkle.remove(), 1000)
    }, 200)
  }

  stopSparkles() {
    if (this.sparkleInterval) {
      clearInterval(this.sparkleInterval)
      this.sparkleInterval = null
    }
  }

  leave() {
    this.resetTilt()
    this.stopSparkles()

    const rainbow = this.cardTarget.querySelector('.holo-rainbow')
    const img = this.cardTarget.querySelector('.character-image-wrapper')

    if (rainbow) rainbow.style.opacity = '0'
    if (img) img.style.transform = 'translateX(0) translateY(0)'

    // Clear sparkles
    const sparkles = this.cardTarget.querySelectorAll('.sparkle')
    sparkles.forEach(s => s.remove())
  }

  resetTilt() {
    this.cardTarget.style.transform = `perspective(1000px) rotateX(0) rotateY(0) scale(1)`
    this.cardTarget.style.boxShadow = '0 10px 30px rgba(0, 0, 0, 0.1)'
  }
}
