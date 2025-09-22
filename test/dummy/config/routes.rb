Rails.application.routes.draw do
  mount Lms::Engine => "/lms"

  namespace :admin do
    mount Lms::Engine => "/lms"
  end

  root to: "lms/home#index"
end
