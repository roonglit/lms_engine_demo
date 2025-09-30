Lms::Engine.routes.draw do
	constraints(->(req) { req.path.include?('admin')}) do
		scope module: 'admin', as: :admin do
			resources :courses
		end
	end

  resources :courses, only: %i[index show]

	root to: "courses#index"
end
