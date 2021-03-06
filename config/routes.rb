Rails.application.routes.draw do

  get 'sessions/new'

  root 'pages#home'
  get :home, controller: :pages, action: :home
  get :about, controller: :pages, action: :about
  get :documentation, controller: :pages, action: :documentation
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'


resources :problems, only: [:index, :show, :new, :create] do
  member do
    post :test
  end
end

  namespace :admin do
    resources :problems do
      member do
        post :approve
        post :unapprove
        post :generate_testcase
      end
    end

    resources :test_cases, only: [:destroy]
  end
end
