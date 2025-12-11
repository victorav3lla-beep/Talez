import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    this.timeouts = []

    // Auto-dismiss after 4 seconds
    this.messageTargets.forEach((message) => {
      const timeoutId = setTimeout(() => {
        this.dismissMessage(message)
      }, 4000)
      this.timeouts.push(timeoutId)
    })
  }

  disconnect() {
    // Clear all timeouts when navigating away (Turbo)
    this.timeouts.forEach((id) => clearTimeout(id))
    this.timeouts = []
  }

  dismiss(event) {
    const message = event.currentTarget.closest('.toast')
    this.dismissMessage(message)
  }

  dismissMessage(message) {
    if (!message || message.classList.contains('toast-hiding')) return

    message.classList.add('toast-hiding')

    // Remove after animation completes
    setTimeout(() => {
      if (message.parentNode) {
        message.remove()
      }

      // Remove container if empty and still in DOM
      if (this.element && this.element.parentNode && this.element.querySelectorAll('.toast').length === 0) {
        this.element.remove()
      }
    }, 300)
  }
}
