Rails.application.routes.draw do
  devise_for :users
  root 'issues#index'
  resources :issues do
    post 'fork', on: :member
    resources :propositions, shallow: true do
      resources :stands
    end
    resources :comments
  end

  resources :status do
    resources :replies
  end
end
