import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    if (event.target.type === "checkbox") {
      if (event.target.checked) {
        document.body.classList.add("scheme-forest")
      } else {
        document.body.classList.remove("scheme-forest")
      }
      return
    }

    document.body.classList.toggle("scheme-forest")
  }

  connect() {
    if (this.element.tagName === "BUTTON") {
      this.element.addEventListener("click", () => {
        document.body.classList.toggle("scheme-forest")
      })
    }
  }
}
