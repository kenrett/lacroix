Rails.application.routes.draw do
  root to: 'messages#index'

  resources :intakes, only: [:create]
  post '/message' => 'messages#index'
  get '/provision' => 'provisions#index'
  get '/auth' => 'auths#index'
end
