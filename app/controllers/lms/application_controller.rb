module Lms
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!

    # Make current_user available in views
    helper_method :current_user
  end
end
