import { Controller } from "@hotwired/stimulus"

// Hero Carousel Controller for TALEZ
// Handles counter animations, button interactions, and enhanced carousel behavior
export default class extends Controller {
  static targets = ["storyCount", "progressBadge", "ctaButton", "ctaText"]

  connect() {
    // Animate counter on load
    this.animateCounter()

    // Optional: Track carousel slides for analytics
    this.setupCarouselTracking()

    // Initialize CTA text for first slide
    this.updateCTAText()
  }

  // Animate the story count number with a pop effect
  animateCounter() {
    if (!this.hasStoryCountTarget) return

    const countElement = this.storyCountTarget
    const finalCount = parseInt(countElement.textContent)

    // Reset to 0 and animate up
    if (finalCount > 0) {
      let currentCount = 0
      const increment = Math.ceil(finalCount / 20) // Animate in ~20 steps
      const duration = 1000 // 1 second total animation

      const timer = setInterval(() => {
        currentCount += increment
        if (currentCount >= finalCount) {
          currentCount = finalCount
          clearInterval(timer)
          // Add pop animation class
          countElement.classList.add('animated')
        }
        countElement.textContent = currentCount
      }, duration / 20)
    }
  }

  // Button hover effect - add extra class for enhanced animation
  buttonHover(event) {
    const button = event.currentTarget
    button.classList.add('hovering')
  }

  // Button leave effect - remove hover class
  buttonLeave(event) {
    const button = event.currentTarget
    button.classList.remove('hovering')
  }

  // Setup carousel event tracking (optional)
  setupCarouselTracking() {
    const carousel = document.getElementById('heroCarousel')
    if (!carousel) return

    // Listen for slide changes
    carousel.addEventListener('slide.bs.carousel', (event) => {
      console.log(`Carousel sliding to: ${event.to}`)
      // You can add analytics tracking here
      // Example: trackEvent('carousel_slide', { slide: event.to })
    })

    // Listen for slid (after transition)
    carousel.addEventListener('slid.bs.carousel', (event) => {
      console.log(`Carousel slid to: ${event.to}`)
      // Add any post-slide animations or effects here
      this.addSlideEffects(event.to)
      // Update CTA button text based on current slide
      this.updateCTAText()
    })
  }

  // Update CTA button text based on active slide
  updateCTAText() {
    if (!this.hasCtaTextTarget) return

    const activeSlide = document.querySelector('.carousel-item.active')
    if (!activeSlide) return

    const ctaText = activeSlide.dataset.ctaText || 'Create New Story'

    // Fade out
    this.ctaTextTarget.style.opacity = '0'

    // Change text after fade out
    setTimeout(() => {
      this.ctaTextTarget.textContent = ctaText
      // Fade in
      this.ctaTextTarget.style.opacity = '1'
    }, 150)
  }

  // Add special effects when slide changes
  addSlideEffects(slideIndex) {
    // You can add slide-specific effects here
    // For example, trigger different sparkle patterns per slide
    const slides = document.querySelectorAll('.carousel-item')

    // Reset all sparkles
    slides.forEach(slide => {
      const sparkles = slide.querySelectorAll('.sparkle')
      sparkles.forEach(sparkle => {
        sparkle.style.animation = 'none'
        // Trigger reflow
        void sparkle.offsetWidth
        sparkle.style.animation = null
      })
    })
  }

  // Pause carousel on hover (optional - more control for kids)
  pauseCarousel() {
    const carouselElement = document.getElementById('heroCarousel')
    if (carouselElement) {
      const carousel = bootstrap.Carousel.getInstance(carouselElement)
      if (carousel) carousel.pause()
    }
  }

  // Resume carousel (optional)
  resumeCarousel() {
    const carouselElement = document.getElementById('heroCarousel')
    if (carouselElement) {
      const carousel = bootstrap.Carousel.getInstance(carouselElement)
      if (carousel) carousel.cycle()
    }
  }

  disconnect() {
    // Cleanup if needed
  }
}
