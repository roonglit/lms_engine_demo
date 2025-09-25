// Import controllers and register them with the main application
import { application } from "controllers/application"
import CurriculumController from "lms/controllers/curriculum_controller"
import SectionController from "lms/controllers/section_controller"

// Register the course controller with the lms-- prefix
application.register("lms--curriculum", CurriculumController)
application.register("lms--section", SectionController)