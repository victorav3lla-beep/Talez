import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const button = document.getElementById("toggle-scheme")
    if (!button) return

    button.addEventListener("click", () => {
      document.body.classList.toggle("scheme-forest")
    })
  }
}
