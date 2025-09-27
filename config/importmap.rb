# Pin the controllers index
# pin "lms/controllers", to: "lms/controllers/index.js"

# pin "controllers/lms", to: Lms::Engine.root.join("app/javascript/controllers/lms/index.js")
pin_all_from Lms::Engine.root.join("app/javascript/controllers/lms"), under: "controllers/lms"
