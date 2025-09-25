# Pin the controllers index
pin "lms/controllers", to: "lms/controllers/index.js"

# Explicitly pin individual controllers
pin "lms/controllers/curriculum_controller", to: "lms/controllers/curriculum_controller.js"
pin "lms/controllers/section_controller", to: "lms/controllers/section_controller.js"