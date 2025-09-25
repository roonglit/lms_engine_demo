require "simple_form"

module Lms
  class Engine < ::Rails::Engine
    isolate_namespace Lms

    # Add engine's assets to loading path
    # config.before_configuration do
    #   config.assets.paths << root.join("app/assets/builds")
    # end

    # # Add engine's built CSS to precompile list
    # initializer "lms.assets" do |app|
    #   app.config.assets.precompile += %w[lms/admin/tailwind.css]
    # end

    initializer "lms.assets" do |app|
      app.config.assets.paths << root.join("app/javascript")
    end

    # Make sure engine's importmap is loaded after main app's importmap
    initializer "lms.importmap", after: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
      end
    end
  end
end
