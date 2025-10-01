module Lms
  module UserHelper
    # Provides access to the current user from the main application
    def current_user
      # Try to access current_user through the controller
      if controller.respond_to?(:current_user, true)
        controller.send(:current_user)
      elsif defined?(warden) && warden.user
        # Access through warden if available (Devise uses warden)
        warden.user
      else
        # Fallback to main_app approach
        nil
      end
    end
    
    # Additional user-related helpers
    def user_signed_in?
      current_user.present?
    end
    
    def user_email
      current_user&.email
    end
    
    def user_full_name
      # Add logic for full name if your User model has first_name/last_name
      current_user&.email # fallback to email for now
    end
  end
end