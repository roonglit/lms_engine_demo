require_relative "lib/lms/version"

Gem::Specification.new do |spec|
  spec.name        = "lms"
  spec.version     = Lms::VERSION
  spec.authors     = [ "Roonglit Chareonsupkul" ]
  spec.email       = [ "roonglit@gmail.com" ]
  spec.homepage    = "lms"
  spec.summary     = "Learning Management System"
  spec.description = "Learning Management System"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "github.com/roonglit/lms_engein_demo.git"
  spec.metadata["changelog_uri"] = ""

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.0.beta1"
  spec.add_dependency "slim-rails"
  spec.add_dependency "simple_form"
  spec.add_dependency "importmap-rails"
  spec.add_dependency "turbo-rails"
  spec.add_dependency "stimulus-rails"
  spec.add_dependency "rails_icons"
  spec.add_dependency "wicked"

  spec.add_development_dependency "tailwindcss-rails"
end
