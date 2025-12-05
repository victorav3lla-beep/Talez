// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import ThemeToggleController from "./theme_toggle_controller"
application.register("theme-toggle", ThemeToggleController)

import StatCounterController from "./stat_counter_controller"
application.register("stat-counter", StatCounterController)
