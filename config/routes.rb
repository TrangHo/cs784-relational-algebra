Rails.application.routes.draw do

  root 'pages#home'
  get :home, controller: :pages, action: :home
  get :about, controller: :pages, action: :about

  resources :problems, only: [:index, :show, :new, :create]
end
