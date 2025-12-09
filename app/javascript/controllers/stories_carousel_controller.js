import { Controller } from "@hotwired/stimulus"

// Stories Carousel Controller for horizontal scrolling
export default class extends Controller {
  static targets = ["container"]

  scrollLeft() {
    const container = this.element.querySelector('.stories-scroll-container')
    if (container) {
      const scrollAmount = container.offsetWidth * 0.8
      container.scrollBy({
        left: -scrollAmount,
        behavior: 'smooth'
      })
    }
  }

  scrollRight() {
    const container = this.element.querySelector('.stories-scroll-container')
    if (container) {
      const scrollAmount = container.offsetWidth * 0.8
      container.scrollBy({
        left: scrollAmount,
        behavior: 'smooth'
      })
    }
  }
}
