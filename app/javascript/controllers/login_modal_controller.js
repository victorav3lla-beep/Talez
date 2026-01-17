import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="login-modal"
export default class extends Controller {
  static targets = ["panel", "backdrop", "loginForm", "signupForm"]

  connect() {
    // Close on escape key
    this.boundKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.boundKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundKeydown)
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  open() {
    this.panelTarget.classList.add("open")
    this.backdropTarget.classList.add("visible")
    document.body.style.overflow = "hidden"
  }

  close() {
    this.panelTarget.classList.remove("open")
    this.backdropTarget.classList.remove("visible")
    document.body.style.overflow = ""
  }

  showLogin() {
    this.loginFormTarget.classList.remove("hidden")
    this.signupFormTarget.classList.add("hidden")
  }

  showSignup() {
    this.loginFormTarget.classList.add("hidden")
    this.signupFormTarget.classList.remove("hidden")
  }

  // Close when clicking backdrop
  backdropClick(event) {
    if (event.target === this.backdropTarget) {
      this.close()
    }
  }
}
