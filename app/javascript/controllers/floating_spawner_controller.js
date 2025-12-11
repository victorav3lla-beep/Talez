import { Controller } from "@hotwired/stimulus"

/**
 * Manages the spawning and lifecycle of floating objects.
 * Keeps maximum 1 object on screen, spawns rarely for subtle effect.
 */
export default class extends Controller {
  static targets = ["pool"]
  static values = {
    images: Array
  }

  connect() {
    // Liste des images disponibles (depuis les data attributes)
    this.vectorImages = this.imagesValue

    this.maxFloaters = 1
    this.spawnChance = 0.25 // 25% chance to spawn when checking
    this.activeFloaters = []

    // Pour éviter les doublons et alterner
    this.usedIndices = [] // Indices actuellement à l'écran
    this.recentIndices = [] // Historique des 4 derniers utilisés

    // Position de la souris (partagée avec tous les floaters)
    this.mouseX = window.innerWidth / 2
    this.mouseY = window.innerHeight / 2

    this.handleMouseMove = this.handleMouseMove.bind(this)
    window.addEventListener('mousemove', this.handleMouseMove)

    // Delayed initial spawn (wait 3-8 seconds before first one)
    const initialDelay = 3000 + Math.random() * 5000
    setTimeout(() => this.spawn(), initialDelay)

    // Check périodique pour respawn (every 4 seconds)
    this.checkInterval = setInterval(() => this.checkAndSpawn(), 4000)
  }

  disconnect() {
    window.removeEventListener('mousemove', this.handleMouseMove)
    clearInterval(this.checkInterval)

    // Clean up all floaters when leaving page (prevents duplicates with Turbo)
    this.activeFloaters.forEach(floater => {
      if (floater.parentNode) {
        floater.remove()
      }
    })
    this.activeFloaters = []
    this.usedIndices = []
  }

  handleMouseMove(event) {
    this.mouseX = event.clientX
    this.mouseY = event.clientY
  }

  checkAndSpawn() {
    // Nettoyer les floaters qui ont fini
    this.activeFloaters = this.activeFloaters.filter(f => f.isConnected)

    // Only spawn if no floater AND random chance succeeds (makes it rare)
    if (this.activeFloaters.length < this.maxFloaters && Math.random() < this.spawnChance) {
      this.spawn()
    }
  }

  spawn() {
    // Choisir un index en évitant les doublons et en alternant
    let vectorIndex = this.chooseUniqueIndex()
    const vector = this.vectorImages[vectorIndex]

    // Créer l'élément
    const floater = document.createElement('div')
    floater.className = 'floater'
    floater.dataset.controller = 'wander'
    floater.dataset.wanderSpawnerValue = this.element.id
    floater.dataset.vectorIndex = vectorIndex // Stocker l'index pour le cleanup

    // Créer l'image
    const img = document.createElement('img')
    img.src = vector.src
    img.alt = vector.alt
    img.style.width = `${vector.width}px`

    floater.appendChild(img)
    this.poolTarget.appendChild(floater)

    this.activeFloaters.push(floater)
    this.usedIndices.push(vectorIndex)
  }

  chooseUniqueIndex() {
    // Créer une liste d'indices disponibles
    let availableIndices = []

    for (let i = 0; i < this.vectorImages.length; i++) {
      // Éviter les indices déjà à l'écran
      if (!this.usedIndices.includes(i)) {
        // Préférer ceux qui n'ont pas été utilisés récemment
        if (!this.recentIndices.includes(i)) {
          availableIndices.push(i)
        }
      }
    }

    // Si tous les objets sont dans les récents, autoriser leur réutilisation
    if (availableIndices.length === 0) {
      for (let i = 0; i < this.vectorImages.length; i++) {
        if (!this.usedIndices.includes(i)) {
          availableIndices.push(i)
        }
      }
    }

    // Si vraiment aucun disponible (cas limite), prendre n'importe lequel
    if (availableIndices.length === 0) {
      availableIndices = Array.from({ length: this.vectorImages.length }, (_, i) => i)
    }

    // Choisir aléatoirement parmi les disponibles
    const chosenIndex = availableIndices[Math.floor(Math.random() * availableIndices.length)]

    // Ajouter aux récents (garder max 4)
    this.recentIndices.push(chosenIndex)
    if (this.recentIndices.length > 4) {
      this.recentIndices.shift()
    }

    return chosenIndex
  }

  // Méthode appelée par les floaters pour obtenir la position de la souris
  getMousePosition() {
    return { x: this.mouseX, y: this.mouseY }
  }

  // Méthode appelée par un floater quand il termine sa traversée
  removeFloater(floater) {
    // Retirer de la liste des indices utilisés
    const vectorIndex = parseInt(floater.dataset.vectorIndex)
    this.usedIndices = this.usedIndices.filter(i => i !== vectorIndex)

    this.activeFloaters = this.activeFloaters.filter(f => f !== floater)
    if (floater.parentNode) {
      floater.remove()
    }
  }
}
