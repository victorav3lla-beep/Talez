import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.isOpen = false
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    this.isOpen = !this.isOpen

    if (this.isOpen) {
      this.menuTarget.classList.add("active")
      document.addEventListener("click", this.closeOnClickOutside.bind(this))
    } else {
      this.menuTarget.classList.remove("active")
      document.removeEventListener("click", this.closeOnClickOutside.bind(this))
    }
  }

  close() {
    this.isOpen = false
    this.menuTarget.classList.remove("active")
    document.removeEventListener("click", this.closeOnClickOutside.bind(this))
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnClickOutside.bind(this))
  }
}
