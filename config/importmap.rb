pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/activestorage", to: "@rails--activestorage.js" # @8.0.300
pin "@rails/actiontext", to: "actiontext.esm.js"

pin "lms/application", preload: true
# Pin all controller files following the *_controller.js naming convention
pin_all_from Lms::Engine.root.join("app/javascript/lms/controllers"), under: "controllers", to: "lms/controllers"

pin "trix"
pin "filepond" # @4.32.9
pin "filepond-plugin-image-preview" # @4.6.12