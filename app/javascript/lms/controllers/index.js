// Import controllers and register them with the main application
import { application } from "controllers/application"
import CourseController from "lms/controllers/course_controller"

// Register the course controller with the lms-- prefix
application.register("lms--course", CourseController)
