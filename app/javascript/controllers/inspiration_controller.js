import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "chip"]

  select(event) {
    const chip = event.currentTarget
    const prompt = chip.dataset.prompt

    // Update input value
    if (this.hasInputTarget) {
      this.inputTarget.value = prompt
      this.inputTarget.focus()
    }

    // Toggle active state
    this.chipTargets.forEach(c => c.classList.remove('active'))
    chip.classList.add('active')
  }
}
