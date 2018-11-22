Rails.application.routes.draw do

  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      patch 'like'
      patch 'dislike'
    end
  end

  concern :commentable do
    resources :comments, only: [:create, :update, :destroy], shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :attachments, shallow: true, only: %i[destroy]
    resources :answers, shallow: true, concerns: [:votable, :commentable], only: %i[create destroy update] do
      resources :attachments, shallow: true, only: %i[destroy]
      patch :find_best_answer, on: :member
    end
  end

  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
