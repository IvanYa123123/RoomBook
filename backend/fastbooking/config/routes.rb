Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post   "signup", to: "auth#signup"
      post   "login",  to: "auth#login"
      delete "logout", to: "auth#logout"
      get    "me",     to: "auth#me"

      resources :hotels, only: %i[index show] do
        resources :bookings, only: %i[create]
        resources :reviews,  only: %i[create]
      end

      namespace :guest do
        resources :bookings, only: %i[index] do
          member { patch :cancel }
        end
      end

      namespace :host do
        resources :hotels do
          resources :rooms, only: %i[index create update destroy]
        end
        resources :bookings, only: %i[index] do
          member do
            patch :confirm
            patch :reject
          end
        end
      end
    end
  end

  root "pages#home"

  resources :hotels, only: %i[index show] do
    resources :bookings, only: %i[new create]
    resources :reviews,  only: %i[create]
  end

  get    "signup", to: "registrations#new",    as: :signup
  post   "signup", to: "registrations#create"
  get    "login",  to: "sessions#new",         as: :login
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy",     as: :logout

  namespace :guest do
    resources :bookings, only: %i[index] do
      member { patch :cancel }
    end
  end

  namespace :host do
    resources :hotels do
      resources :rooms, only: %i[index new create edit update destroy]
    end
    resources :bookings, only: %i[index] do
      member do
        patch :confirm
        patch :reject
      end
    end
  end
end
