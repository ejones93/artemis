Rails.application.routes.draw do
  root		'static_pages#home'
  get 		'/help',	            to: 'static_pages#help'
  get 		'/about',	            to: 'static_pages#about'
  get 		'/contact',	          to: 'static_pages#contact'
  get 		'/signup',            to: 'users#new'
  get     '/rounds/:id/print',  to: 'rounds#print', as: :print
  get 		'/login',	            to: 'sessions#new'
  post		'/login',	            to: 'sessions#create'
  delete 	'/logout',	          to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :scores,              only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :rounds,              only: [:show, :index]
  resources :categories,          only: [:show, :index]
  
end