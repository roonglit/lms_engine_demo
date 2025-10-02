module Lms
  class HomeController < ApplicationController
    def index
      @contents = Content.all
    end
  end
end
