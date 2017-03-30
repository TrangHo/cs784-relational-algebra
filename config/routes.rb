Rails.application.routes.draw do

  root 'pages#home'
  get :home, controller: :pages, action: :home
  get :about, controller: :pages, action: :about
  get :problems, controller: :pages, action: :problems

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
