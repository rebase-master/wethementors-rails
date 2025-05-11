Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  # Main routes
  resources :programs do
    member do
      post 'enroll'
      post 'unenroll'
      get 'progress'
      get 'related'
    end
    resources :program_comments, only: [:create, :update, :destroy] do
      member do
        post 'flag'
        delete 'unflag'
      end
    end
  end

  resources :qa, controller: 'qa', as: 'qa' do
    member do
      post 'vote'
    end
    resources :answers, controller: 'qa_answers', only: [:create, :edit, :update, :destroy] do
      member do
        post 'vote'
      end
    end
  end

  resources :quiz, controller: 'quiz' do
    member do
      get 'high_scores'
      get 'progress'
      get 'statistics'
    end
    resources :questions, controller: 'quiz_questions', only: [:show, :new, :create, :edit, :update, :destroy] do
      collection do
        post 'submit'
      end
    end
  end

  resources :yearly_questions do
    collection do
      get ':subject/:type/:slug', to: 'yearly_questions#show', as: :show_by_slug
    end
  end

  resources :subjects do
    collection do
      get ':url_name', to: 'subjects#show', as: :show_by_url_name
    end
  end

  resources :topics do
    collection do
      get ':url_name', to: 'topics#show', as: :show_by_url_name
    end
  end

  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'authentication#create'
      delete 'auth/logout', to: 'authentication#destroy'
      
      # Profile Management
      resources :profiles, only: [:show, :update, :destroy] do
        collection do
          get 'options'
        end
      end
      resources :profile_options, only: [:index, :show, :create, :update, :destroy]
      
      # Program Management
      resources :programs, only: [:index, :create, :update, :destroy] do
        member do
          post 'enroll'
          post 'unenroll'
          get 'progress'
          get 'related'
        end
        
        resources :program_sections, shallow: true do
          resources :milestones, shallow: true do
            member do
              post :complete
            end
          end
          member do
            post :complete
          end
        end

        resources :program_ratings, shallow: true do
          member do
            post :flag
            post :unflag
            post :vote_helpful
            post :vote_unhelpful
            delete :remove_vote
          end
        end

        resources :program_certificates, shallow: true do
          member do
            post :revoke
            post :expire
            get :download
          end
        end
      end

      resources :users, only: [:show, :update] do
        resources :profiles, only: [:show, :update]
      end

      # Tags
      resources :tags, only: [:index, :create, :update, :destroy] do
        collection do
          get ':name', to: 'tags#show', as: :show_by_name
        end
      end

      # Notifications
      resources :notifications, only: [:index, :show, :destroy] do
        collection do
          post :mark_all_as_read
          post :mark_all_as_unread
          delete :destroy_all
        end
        member do
          post :mark_as_read
          post :mark_as_unread
        end
      end

      get 'certificates/verify/:verification_code', to: 'program_certificates#verify'
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"
end
