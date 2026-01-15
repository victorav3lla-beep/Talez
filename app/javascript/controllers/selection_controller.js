import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="selection"
export default class extends Controller {
  static targets = ["card", "input", "submitButton"]

  connect() {

    if (!this.hasSubmitButtonTarget) {
      console.warn("Submit button NOT found!")
    }
  }

  select(event) {

    const clickedCard = event.currentTarget
    const characterId = clickedCard.dataset.id

    // Remove selected class from all cards
    this.cardTargets.forEach(card => {
      card.classList.remove("selected")
    })

    // Add selected class to clicked card
    clickedCard.classList.add("selected")

    if (this.hasInputTarget) {
      this.inputTarget.value = characterId
    } else {
      console.warn("Input target not found!")
    }

    // Enable submit button - FORCE IT
    if (this.hasSubmitButtonTarget) {
      const btn = this.submitButtonTarget

      // Try both methods
      btn.disabled = false
      btn.removeAttribute("disabled")
    } else {
      console.warn("Submit button target not found!")
    }
  }
}
