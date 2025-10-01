require "lms/version"
require "lms/engine"

require "importmap-rails"
require "turbo-rails"
require "stimulus-rails"

module Lms
  class << self
    attr_accessor :configuration
  end

  class Configuration
    attr_reader :importmap

    def initialize
      @importmap = Importmap::Map.new
      @importmap.draw(Engine.root.join("config/importmap.rb"))
    end
  end

  def self.init_config
    self.configuration ||= Configuration.new
  end
end

Lms.init_config
