Rails.application.routes.draw do

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  devise_for :users
  mount Lms::Engine => "/lms"

  namespace :admin do
    mount Lms::Engine => "/lms"
  end

  root to: redirect("/lms")
end
