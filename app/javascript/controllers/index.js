// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)



// import StatCounterController from "./stat_counter_controller"
// application.register("stat-counter", StatCounterController)
