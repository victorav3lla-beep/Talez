import { Controller } from "@hotwired/stimulus"

// Story Filter Controller for TALEZ
// Handles filtering and sorting of story cards without page reload
export default class extends Controller {
  static targets = ["card", "grid"]

  connect() {
    this.currentFilter = "all"
    this.currentSort = "recent"
  }

  // Filter stories by status/type
  filterStories(event) {
    const button = event.currentTarget
    const filter = button.dataset.filter

    // Update active button state
    this.updateActiveButton(button)

    // Store current filter
    this.currentFilter = filter

    // Apply filter
    this.applyFilter()
  }

  // Sort stories
  sortStories(event) {
    const sortType = event.target.value
    this.currentSort = sortType

    // Apply current filter and sort
    this.applyFilter()
  }

  // Apply filter and sort to cards
  applyFilter() {
    const cards = this.cardTargets
    let visibleCards = []

    // Add fade-out effect
    cards.forEach(card => {
      card.classList.add('fade-out')
    })

    // Wait for fade-out, then filter
    setTimeout(() => {
      cards.forEach(card => {
        const shouldShow = this.shouldShowCard(card)

        if (shouldShow) {
          card.classList.remove('hidden', 'fade-out')
          visibleCards.push(card)
        } else {
          card.classList.add('hidden')
          card.classList.remove('fade-out')
        }
      })

      // Sort visible cards
      this.sortCards(visibleCards)

      // Check if no results
      this.handleNoResults(visibleCards.length === 0)
    }, 150)
  }

  // Determine if card should be visible based on current filter
  shouldShowCard(card) {
    const status = card.dataset.status
    const isPublic = card.dataset.public === "true"

    switch (this.currentFilter) {
      case "all":
        return true
      case "draft":
        return status === "draft"
      case "complete":
        return status === "complete"
      case "public":
        return isPublic
      default:
        return true
    }
  }

  // Sort cards based on current sort option
  sortCards(cards) {
    const grid = this.gridTarget

    // Convert to array and sort
    const sortedCards = cards.sort((a, b) => {
      switch (this.currentSort) {
        case "recent":
          return parseInt(b.dataset.createdAt) - parseInt(a.dataset.createdAt)
        case "oldest":
          return parseInt(a.dataset.createdAt) - parseInt(b.dataset.createdAt)
        case "liked":
          return parseInt(b.dataset.likes) - parseInt(a.dataset.likes)
        default:
          return 0
      }
    })

    // Reorder DOM elements
    sortedCards.forEach(card => {
      grid.appendChild(card)
    })
  }

  // Update active button state
  updateActiveButton(clickedButton) {
    // Remove active class from all filter buttons
    const allButtons = this.element.querySelectorAll('.filter-pill')
    allButtons.forEach(btn => btn.classList.remove('active'))

    // Add active class to clicked button
    clickedButton.classList.add('active')
  }

  // Handle no results state
  handleNoResults(isEmpty) {
    const grid = this.gridTarget
    let noResultsMessage = this.element.querySelector('.no-results-message')

    if (isEmpty) {
      // Create no results message if it doesn't exist
      if (!noResultsMessage) {
        noResultsMessage = document.createElement('div')
        noResultsMessage.className = 'no-results-message'
        noResultsMessage.innerHTML = `
          <div class="no-results-icon">🔍</div>
          <h3>No stories found</h3>
          <p>Try a different filter or create a new story!</p>
        `
        grid.parentElement.appendChild(noResultsMessage)
      }
      noResultsMessage.classList.add('visible')
    } else {
      if (noResultsMessage) {
        noResultsMessage.classList.remove('visible')
      }
    }
  }
}
