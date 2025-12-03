import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="selection"
export default class extends Controller {
  static targets = ["card", "input", "submitButton"]

  connect() {
    console.log("Selection controller connected")
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

    // Update hidden input value
    this.inputTarget.value = characterId

    // Enable submit button
    this.submitButtonTarget.disabled = false
  }
}
