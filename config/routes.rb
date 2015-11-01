Rails.application.routes.draw do
  devise_for :users
  root 'issues#index'
  resources :issues do
    resources :propositions, shallow: true do
      resources :stands
    end
    resources :comments
  end
end
