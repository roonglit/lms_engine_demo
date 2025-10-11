module Lms
  class PostsController < ApplicationController
    include Wicked::Wizard

    steps :step1, :step2, :step3

    def show
      case step
      when :step1
        render_wizard
      when :step2
        render_wizard
      when :step3
        render_wizard
      end
    end

    def new
    end
  end
end
