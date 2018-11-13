Rails.application.routes.draw do

  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :attachments, shallow: true, only: %i[destroy]
    resources :answers, shallow: true, only: %i[create destroy update] do
      resources :attachments, shallow: true, only: %i[destroy]
      patch :find_best_answer, on: :member
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
