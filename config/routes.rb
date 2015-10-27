Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  resources :issues do
    resources :propositions
    resources :comments
  end
end
