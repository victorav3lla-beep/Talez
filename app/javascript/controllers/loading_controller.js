// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static targets = ["starsContainer", "bookCatcher", "score"]

//   connect() {
//     this.createStars()
//     this.setupDragging()
//     this.scoreValue = 0
//     this.startFallingStars()
//   }

//   createStars() {
//     for (let i = 0; i < 50; i++) {
//       const star = document.createElement("div")
//       star.className = "bg-star"
//       star.style.left = Math.random() * 100 + "%"
//       star.style.top = Math.random() * 100 + "%"
//       star.style.animationDelay = Math.random() * 3 + "s"
//       this.starsContainerTarget.appendChild(star)
//     }
//   }

//   setupDragging() {
//     let isDragging = false
//     let xOffset = 0
//     let currentX
//     let initialX

//     const book = this.bookCatcherTarget

//     const dragStart = e => {
//       initialX = e.type.includes("touch") ? e.touches[0].clientX - xOffset : e.clientX - xOffset
//       isDragging = true
//     }

//     const drag = e => {
//       if (!isDragging) return
//       e.preventDefault()
//       currentX = e.type.includes("touch") ? e.touches[0].clientX - initialX : e.clientX - initialX
//       xOffset = currentX
//       const maxX = window.innerWidth - book.offsetWidth
//       const boundedX = Math.max(0, Math.min(currentX, maxX))
//       book.style.left = boundedX + "px"
//       book.style.transform = "translateX(0)"
//     }

//     const dragEnd = () => { isDragging = false }

//     book.addEventListener("mousedown", dragStart)
//     book.addEventListener("touchstart", dragStart)
//     document.addEventListener("mousemove", drag)
//     document.addEventListener("touchmove", drag)
//     document.addEventListener("mouseup", dragEnd)
//     document.addEventListener("touchend", dragEnd)
//   }

//   startFallingStars() {
//     setInterval(() => {
//       const star = document.createElement("div")
//       star.className = "falling-star"
//       star.textContent = "⭐"
//       star.style.left = Math.random() * (window.innerWidth - 30) + "px"
//       star.style.animationDuration = 2 + Math.random() * 2 + "s"
//       document.body.appendChild(star)

//       setTimeout(() => star.remove(), 4000)
//     }, 800)
//   }
// }
