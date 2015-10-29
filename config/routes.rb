Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  resources :issues do
    resources :propositions, shallow: true do
      resources :stands
    end
    resources :comments
  end
end
