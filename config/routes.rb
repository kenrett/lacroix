Rails.application.routes.draw do
  resources :intakes, only: [:index, :create]
end
