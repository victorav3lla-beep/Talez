import { Controller } from "@hotwired/stimulus"

/**
 * Creates a "shy fish" effect: elements cross the screen with curves
 * and flee from the mouse cursor, making them uncatchable.
 */
export default class extends Controller {
  connect() {
    // Vitesse de traversée (pixels par frame) - 20% slower
    this.baseSpeed = 1.6 + Math.random() * 1.6 // 1.6-3.2 px/frame

    // Distance de répulsion de la souris (PLUS LOIN)
    this.repelDistance = 400

    // Position actuelle
    this.x = 0
    this.y = 0

    // Vitesse actuelle
    this.vx = 0
    this.vy = 0

    // Pour les virages brusques aléatoires (style voiture de course / ivre)
    this.nextTurnTime = Date.now() + 800 + Math.random() * 1500 // Virages toutes les 0.8-2.3s
    this.turnAngle = 0 // Angle de virage actuel
    this.targetTurnAngle = 0 // Angle de virage cible

    // Définir le spawn et la destination
    this.setupTrajectory()

    // Position initiale (PAS DE ROTATION)
    this.element.style.transform = `translate3d(${this.x}px, ${this.y}px, 0)`

    // Lancer l'animation
    this.animate = this.animate.bind(this)
    this.rafId = requestAnimationFrame(this.animate)
  }

  setupTrajectory() {
    const side = Math.floor(Math.random() * 4) // 0: gauche, 1: droite, 2: haut, 3: bas
    const margin = -100 // Spawn hors écran

    switch(side) {
      case 0: // Entre par la gauche
        this.x = margin
        this.y = Math.random() * window.innerHeight
        this.targetX = window.innerWidth + 100
        this.targetY = Math.random() * window.innerHeight
        break
      case 1: // Entre par la droite
        this.x = window.innerWidth - margin
        this.y = Math.random() * window.innerHeight
        this.targetX = -100
        this.targetY = Math.random() * window.innerHeight
        break
      case 2: // Entre par le haut
        this.x = Math.random() * window.innerWidth
        this.y = margin
        this.targetX = Math.random() * window.innerWidth
        this.targetY = window.innerHeight + 100
        break
      case 3: // Entre par le bas
        this.x = Math.random() * window.innerWidth
        this.y = window.innerHeight - margin
        this.targetX = Math.random() * window.innerWidth
        this.targetY = -100
        break
    }

    // Direction de base vers la cible
    const dx = this.targetX - this.x
    const dy = this.targetY - this.y
    const dist = Math.sqrt(dx * dx + dy * dy)

    this.vx = (dx / dist) * this.baseSpeed
    this.vy = (dy / dist) * this.baseSpeed
  }

  getSpawnerController() {
    // Trouve le controller spawner parent
    const spawner = document.querySelector('[data-controller~="floating-spawner"]')
    if (spawner) {
      return this.application.getControllerForElementAndIdentifier(spawner, 'floating-spawner')
    }
    return null
  }

  animate() {
    // Obtenir la position de la souris
    const spawner = this.getSpawnerController()
    let mouseX = window.innerWidth / 2
    let mouseY = window.innerHeight / 2

    if (spawner) {
      const mousePos = spawner.getMousePosition()
      mouseX = mousePos.x
      mouseY = mousePos.y
    }

    // Calculer la distance à la souris
    const dx = this.x - mouseX
    const dy = this.y - mouseY
    const distToMouse = Math.sqrt(dx * dx + dy * dy)

    // RÉPULSION : Si trop proche de la souris, fuir ! (ENCORE PLUS DOUCE)
    if (distToMouse < this.repelDistance && distToMouse > 0) {
      const repelStrength = (1 - distToMouse / this.repelDistance) * 1.5 // Force ENCORE PLUS RÉDUITE
      this.vx += (dx / distToMouse) * repelStrength
      this.vy += (dy / distToMouse) * repelStrength
    }

    // Virages brusques aléatoires (comme une voiture qui zigzague)
    if (Date.now() > this.nextTurnTime) {
      // Nouveau virage brusque : angle entre -60° et +60°
      this.targetTurnAngle = (Math.random() - 0.5) * 2 * Math.PI / 3 // -60° à +60° en radians
      this.nextTurnTime = Date.now() + 800 + Math.random() * 1500
    }

    // Interpoler doucement vers l'angle de virage cible
    this.turnAngle += (this.targetTurnAngle - this.turnAngle) * 0.08

    // Appliquer le virage à la vélocité
    const currentAngle = Math.atan2(this.vy, this.vx)
    const newAngle = currentAngle + this.turnAngle * 0.02

    // Calculer la nouvelle direction
    const speed = Math.sqrt(this.vx * this.vx + this.vy * this.vy)
    if (speed > 0) {
      this.vx = Math.cos(newAngle) * speed
      this.vy = Math.sin(newAngle) * speed
    }

    // Appliquer la vélocité
    this.x += this.vx
    this.y += this.vy

    // Damping pour ne pas accélérer à l'infini
    this.vx *= 0.98
    this.vy *= 0.98

    // Recalculer la direction pour revenir vers la cible (doucement)
    const dxTarget = this.targetX - this.x
    const dyTarget = this.targetY - this.y
    const distTarget = Math.sqrt(dxTarget * dxTarget + dyTarget * dyTarget)

    if (distTarget > 0) {
      this.vx += (dxTarget / distTarget) * 0.04
      this.vy += (dyTarget / distTarget) * 0.04
    }

    // Appliquer la transformation (PAS DE ROTATION)
    this.element.style.transform = `translate3d(${this.x}px, ${this.y}px, 0)`

    // Vérifier si l'élément est sorti de l'écran
    if (this.isOutOfBounds()) {
      this.destroy()
      return
    }

    // Continuer l'animation
    this.rafId = requestAnimationFrame(this.animate)
  }

  isOutOfBounds() {
    const margin = 200
    return this.x < -margin ||
           this.x > window.innerWidth + margin ||
           this.y < -margin ||
           this.y > window.innerHeight + margin
  }

  destroy() {
    cancelAnimationFrame(this.rafId)
    const spawner = this.getSpawnerController()
    if (spawner) {
      spawner.removeFloater(this.element)
    }
  }

  disconnect() {
    if (this.rafId) {
      cancelAnimationFrame(this.rafId)
    }
  }
}

