Lms::Engine.routes.draw do
	constraints(->(req) { req.script_name.start_with?('/admin')}) do
		scope module: 'admin', as: :admin do
			resources :articles
			resources :videos
			resources :events
			resources :courses
			resources :categories
		end
	end

	resources :posts, only: %i[show]
	resources :articles do 
		post :preview, on: :collection
	end

	resources :events
  resources :videos
	resources :categories
  resources :courses, only: %i[index show] do
    resources :curriculum_items, only: [:show]
  end

	root to: "home#index"
end
