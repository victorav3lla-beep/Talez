import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

import ThemeToggleController from "./theme_toggle_controller"
application.register("theme-toggle", ThemeToggleController)

export { application }
