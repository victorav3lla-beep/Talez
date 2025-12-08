import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["logo1", "logo2"]
  static values = {
    interval: { type: Number, default: 5000 }
  }

  connect() {
    this.currentLogo = 1
    this.totalLogos = 2
    console.log('Logo switcher connected')
    console.log('Logo 1:', this.logo1Target)
    console.log('Logo 2:', this.logo2Target)

    // Try to sync with carousel if it exists
    const carousel = document.getElementById('heroCarousel')
    if (carousel) {
      console.log('Found carousel, syncing with it')
      this.syncWithCarousel(carousel)
    } else {
      console.log('No carousel found, using own timer')
      this.startSwitching()
    }
  }

  disconnect() {
    this.stopSwitching()
    if (this.carouselListener) {
      const carousel = document.getElementById('heroCarousel')
      if (carousel) {
        carousel.removeEventListener('slide.bs.carousel', this.carouselListener)
      }
    }
  }

  syncWithCarousel(carousel) {
    // Listen to carousel slide events
    this.carouselListener = () => {
      console.log('Carousel sliding, switching logo')
      this.switchLogo()
    }
    carousel.addEventListener('slide.bs.carousel', this.carouselListener)
  }

  startSwitching() {
    this.intervalId = setInterval(() => {
      this.switchLogo()
    }, this.intervalValue)
  }

  stopSwitching() {
    if (this.intervalId) {
      clearInterval(this.intervalId)
    }
  }

  switchLogo() {
    const currentLogoTarget = this[`logo${this.currentLogo}Target`]

    // Fade out current logo
    currentLogoTarget.style.opacity = '0'

    setTimeout(() => {
      // Hide current logo
      currentLogoTarget.style.display = 'none'

      // Calculate next logo (cycle through 1, 2, 3)
      this.currentLogo = (this.currentLogo % this.totalLogos) + 1

      const nextLogoTarget = this[`logo${this.currentLogo}Target`]

      // Show next logo
      nextLogoTarget.style.display = 'block'
      nextLogoTarget.style.opacity = '0'

      setTimeout(() => {
        nextLogoTarget.style.opacity = '1'
      }, 50)

      console.log(`Switched to logo ${this.currentLogo}`)
    }, 300)
  }
}
