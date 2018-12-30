Rails.application.routes.draw do
  root to: 'messages#index'

  resources :intakes, only: [:create]
  post '/message' => 'messages#index'
end
