# Pin the controllers index
pin "lms/controllers", to: "lms/controllers/index.js"

# Pin all controllers from the engine
pin_all_from "app/javascript/lms/controllers", under: "lms/controllers"