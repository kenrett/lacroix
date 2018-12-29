Rails.application.routes.draw do

  resources :intakes, only: [:create]
end
