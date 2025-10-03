Lms::Engine.routes.draw do
	constraints(->(req) { req.script_name.include?('/admin')}) do
		scope module: 'admin', as: :admin do
			resources :articles
			resources :videos
			resources :events
			resources :courses
			resources :categories
		end
	end

	resources :posts, only: %i[show new]
	resources :articles
	resources :events
  resources :videos
	resources :categories
  resources :courses, only: %i[index show]

	root to: "home#index"
end
