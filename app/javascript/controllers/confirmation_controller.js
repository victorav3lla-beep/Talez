import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirmation"
export default class extends Controller {
  confirm(event) {
    const message = event.target.dataset.confirmMessage || "Are you sure you want to delete this story?"

    if (!confirm(message)) {
      event.preventDefault()
      event.stopPropagation()
    }
  }
}
