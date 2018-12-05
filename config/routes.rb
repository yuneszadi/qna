Rails.application.routes.draw do
  use_doorkeeper
  root to: "questions#index"

  devise_for :users, controllers: {registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks'}

  devise_scope :user do
    get 'edit_email/:id', to: 'registrations#edit_email', as: 'edit_email'
    patch 'update_email/:id', to: 'registrations#update_email', as: 'update_email'
  end

  concern :votable do
    member do
      patch 'like'
      patch 'dislike'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create], shallow: true do
        resources :answers, only: %i[index show create]
      end
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
