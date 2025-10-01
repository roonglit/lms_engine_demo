pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin "lms/application", preload: true

# Pin all controller files following the *_controller.js naming convention
pin_all_from Lms::Engine.root.join("app/javascript/lms/controllers"), under: "controllers", to: "lms/controllers"