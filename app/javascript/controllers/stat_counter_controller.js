import { Controller } from "@hotwired/stimulus"

// Stat Counter Controller for TALEZ
// Animates stat numbers from 0 to final value on page load
export default class extends Controller {
  static targets = ["count"]

  connect() {
    this.animateCount()
  }

  animateCount() {
    if (!this.hasCountTarget) return

    const countElement = this.countTarget
    const finalValue = parseInt(countElement.dataset.finalValue) || 0

    // If final value is 0, no need to animate
    if (finalValue === 0) {
      countElement.textContent = "0"
      return
    }

    // Animation settings
    const duration = 1500 // 1.5 seconds
    const steps = 30
    const increment = Math.ceil(finalValue / steps)
    const stepDuration = duration / steps

    let currentValue = 0

    // Animate the counter
    const timer = setInterval(() => {
      currentValue += increment

      if (currentValue >= finalValue) {
        currentValue = finalValue
        clearInterval(timer)
      }

      countElement.textContent = currentValue
    }, stepDuration)
  }
}
