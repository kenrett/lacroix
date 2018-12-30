Rails.application.routes.draw do
  root to: 'intakes#index'

  resources :intakes, only: [:index, :create]
  post '/message' => 'messages#index'
end
