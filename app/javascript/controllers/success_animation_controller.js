import { Controller } from "@hotwired/stimulus"

// Success Animation Controller for TALEZ
// Triggers confetti and toast notifications on story creation
export default class extends Controller {
  connect() {
    // Check for flash message indicating story was created
    const flashSuccess = document.querySelector('[data-flash-success]')

    if (flashSuccess && flashSuccess.dataset.flashSuccess === 'story_created') {
      this.celebrate()
    }
  }

  celebrate() {
    // Trigger confetti
    this.launchConfetti()

    // Show success toast
    this.showSuccessToast()
  }

  // Launch confetti animation (pure CSS/JS implementation)
  launchConfetti() {
    const colors = ['#FF6B6B', '#4ECDC4', '#FFE66D'] // Coral, Teal, Yellow
    const confettiCount = 50

    // Create confetti elements
    for (let i = 0; i < confettiCount; i++) {
      setTimeout(() => {
        this.createConfetti(colors)
      }, i * 30) // Stagger the creation
    }
  }

  createConfetti(colors) {
    const confetti = document.createElement('div')
    confetti.className = 'confetti'

    // Random color
    const colorClass = ['coral', 'teal', 'yellow'][Math.floor(Math.random() * 3)]
    confetti.classList.add(colorClass)

    // Random position and size
    confetti.style.left = Math.random() * 100 + '%'
    confetti.style.width = (Math.random() * 8 + 6) + 'px'
    confetti.style.height = confetti.style.width
    confetti.style.animationDuration = (Math.random() * 2 + 2) + 's'
    confetti.style.animationDelay = Math.random() * 0.5 + 's'

    // Add to body
    document.body.appendChild(confetti)

    // Remove after animation
    setTimeout(() => {
      confetti.remove()
    }, 4000)
  }

  // Show success toast notification
  showSuccessToast() {
    const toast = document.createElement('div')
    toast.className = 'success-toast'
    toast.innerHTML = `
      <span class="toast-icon">🎉</span>
      <span class="toast-message">Story created! Time to write!</span>
      <button class="toast-close" data-action="click->success-animation#closeToast">×</button>
    `

    document.body.appendChild(toast)

    // Auto-remove after 4 seconds
    setTimeout(() => {
      if (toast.parentElement) {
        toast.remove()
      }
    }, 4000)
  }

  closeToast(event) {
    const toast = event.currentTarget.closest('.success-toast')
    if (toast) {
      toast.remove()
    }
  }

  // Alternative: Canvas-based confetti (if canvas-confetti library is installed)
  // Uncomment if you install canvas-confetti via npm
  /*
  async launchCanvasConfetti() {
    // Dynamically import canvas-confetti if installed
    const confetti = await import('canvas-confetti')

    const colors = ['#FF6B6B', '#4ECDC4', '#FFE66D']

    confetti.default({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 },
      colors: colors,
      ticks: 200,
      gravity: 1.2,
      scalar: 1.2
    })

    // Second burst
    setTimeout(() => {
      confetti.default({
        particleCount: 50,
        angle: 60,
        spread: 55,
        origin: { x: 0 },
        colors: colors
      })
    }, 200)

    setTimeout(() => {
      confetti.default({
        particleCount: 50,
        angle: 120,
        spread: 55,
        origin: { x: 1 },
        colors: colors
      })
    }, 400)
  }
  */
}
