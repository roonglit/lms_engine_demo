Lms::Engine.routes.draw do
  resources :videos
	constraints(->(req) { req.path.include?('admin')}) do
		scope module: 'admin', as: :admin do
			resources :courses
		end
	end

	resources :posts, only: %i[new]
	resources :articles
  resources :courses, only: %i[index show]

	root to: "home#index"
end
