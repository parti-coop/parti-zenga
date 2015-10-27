Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  resources :issues do
    resources :propositions
  end
end
