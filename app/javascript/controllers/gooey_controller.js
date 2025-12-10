import { Controller } from "@hotwired/stimulus"

/**
 * Creates a "gooey" or "liquid" trailing effect for a set of blobs that follow the cursor.
 * The physics are based on LERP (Linear Interpolation) with different delays for each blob,
 * creating a sense of inertia and viscosity.
 */
export default class extends Controller {
  static targets = ["blob"]

  connect() {
    this.cursor = { x: window.innerWidth / 2, y: window.innerHeight / 2 }
    this.blobs = this.blobTargets.map(() => ({
      x: window.innerWidth / 2,
      y: window.innerHeight / 2
    }))

    // Liquid Gold delays - b2 leads!
    // HTML order: b4 → b3 → b2 → b1 (small to large)
    // Index 0 (b4 - 150px): Heavy trailer - slowest
    // Index 1 (b3 - 220px): Trailer - slow
    // Index 2 (b2 - 320px): LEADER - fastest, sticks to cursor
    // Index 3 (b1 - 480px): Big follower - 2nd fastest
    this.delays = [0.008, 0.012, 0.20, 0.04]

    // Bind methods once for performance and correct `this` context.
    this.move = this.move.bind(this)
    this.animate = this.animate.bind(this)

    window.addEventListener("mousemove", this.move)
    this.rafId = requestAnimationFrame(this.animate)
  }

  disconnect() {
    window.removeEventListener("mousemove", this.move)
    cancelAnimationFrame(this.rafId)
  }

  /**
   * Updates the cursor's target coordinates on mouse move.
   */
  move(event) {
    this.cursor.x = event.clientX
    this.cursor.y = event.clientY
  }

  /**
   * Animates each blob towards the cursor at its own speed using LERP.
   * This is called on every animation frame.
   */
  animate() {
    this.blobs.forEach((blobState, index) => {
      const blobEl = this.blobTargets[index]
      const delay = this.delays[index]

      // LERP (Linear Interpolation) for smooth, delayed movement.
      blobState.x += (this.cursor.x - blobState.x) * delay
      blobState.y += (this.cursor.y - blobState.y) * delay

      blobEl.style.transform = `translate3d(${blobState.x}px, ${blobState.y}px, 0)`
    })

    this.rafId = requestAnimationFrame(this.animate)
  }
}
