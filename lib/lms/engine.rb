require "simple_form"

module Lms
  class Engine < ::Rails::Engine
    isolate_namespace Lms

    # Add engine's assets to loading path
    # config.before_configuration do
    #   config.assets.paths << root.join("app/assets/builds")
    # end

    # Configure paths for asset pipeline
    config.before_configuration do
      # Add the engine's assets to the load path
      config.assets.paths << root.join("app/assets/stylesheets")
      config.assets.paths << root.join("app/assets/tailwind")
      config.assets.paths << root.join("app/assets/builds")
      config.assets.paths << root.join("app/javascript")
    end

    # Add engine's built CSS to precompile list
    initializer "lms.assets" do |app|
      app.config.assets.precompile += %w[lms/admin/tailwind.css]
      app.config.assets.precompile += %w[lms/application.css]
      app.config.assets.precompile += %w[lms/admin/application.css]
    end

    # Make sure engine's importmap is loaded after main app's importmap
    initializer "lms.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/admin_importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/javascript")
    end
  end
end
