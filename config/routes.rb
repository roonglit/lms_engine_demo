Lms::Engine.routes.draw do
	constraints(->(req) { req.path.start_with?('/admin')}) do
		scope module: 'admin', as: :admin do
			resources :articles
			resources :videos
			resources :events
			resources :courses
		end
	end

	resources :posts, only: %i[show new]
	resources :articles
	resources :events
  resources :videos
  resources :courses, only: %i[index show]

	root to: "home#index"
end
