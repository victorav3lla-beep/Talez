import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="selection"
export default class extends Controller {
  static targets = ["card", "input", "submitButton"]

  connect() {
    console.log("✅ Controller connected")
    console.log("📊 Found targets:", {
      cards: this.cardTargets.length,
      hasInput: this.hasInputTarget,
      hasSubmitButton: this.hasSubmitButtonTarget
    })

    if (this.hasSubmitButtonTarget) {
      console.log("🔘 Submit button found:", this.submitButtonTarget)
    } else {
      console.error("❌ Submit button NOT found!")
    }
  }

  select(event) {
    console.log("🖱️ Card clicked")

    const clickedCard = event.currentTarget
    const characterId = clickedCard.dataset.id

    console.log("🆔 Character ID:", characterId)

    // Remove selected class from all cards
    this.cardTargets.forEach(card => {
      card.classList.remove("selected")
    })

    // Add selected class to clicked card
    clickedCard.classList.add("selected")
    console.log("✨ Added .selected class to card")

    // Update hidden input value
    if (this.hasInputTarget) {
      this.inputTarget.value = characterId
      console.log("📝 Updated hidden input to:", this.inputTarget.value)
    } else {
      console.error("❌ Input target not found!")
    }

    // Enable submit button - FORCE IT
    if (this.hasSubmitButtonTarget) {
      const btn = this.submitButtonTarget

      // Try both methods
      btn.disabled = false
      btn.removeAttribute("disabled")

      console.log("🟢 Button enabled!")
      console.log("   - disabled property:", btn.disabled)
      console.log("   - has disabled attr:", btn.hasAttribute("disabled"))
    } else {
      console.error("❌ Submit button target not found!")
    }
  }
}
