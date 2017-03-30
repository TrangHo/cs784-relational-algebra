Rails.application.routes.draw do

  root 'pages#home'
  get :home, controller: :pages, action: :home
  get :about, controller: :pages, action: :about
  get :problems, controller: :pages, action: :problems

  resources :problems, only: [:new, :create]
end
