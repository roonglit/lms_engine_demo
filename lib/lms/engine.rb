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
  end
end
