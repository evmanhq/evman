Rails.application.routes.draw do

  root 'welcome#index'

  get '/auth/:provider/callback', :to => 'o_auth#callback'
  get '/auth/failure', :to => 'o_auth#failure'

  post 'authenticate', :to => 'welcome#authenticate'
  post '/signin', :to => 'welcome#signin'
  get '/signout', :to => 'welcome#signout'

  get '/dashboard', :to => 'dashboard#index'

  resources :events do
    member do
      get :add_attendee, :expenses, :attachments
      get :approved
      get :committed
      get :archived
    end
    collection do
      get :archive

      get :export
      post :export, to: 'events#generate_export'

      resources :event_talks, :controller => :event_talks, :as => :event_talks do
      end
      resources :attendees, :controller => :attendees do
      end
      resources :expenses, :controller => :expenses do
      end
      resources :event_notes, :controller => :event_notes do
      end
    end
  end

  resources :profile_pictures, except: [:index, :edit, :update] do
    member do
      post :set_default, :toggle_public
      get :download
    end
    collection do
      post :set_gravatar
    end
  end

  resources :user_emails
  resources :identities

  resources :biographies, except: [:index, :show] do
    member do
      post :set_default
    end
  end

  resources :users do
    get 'email_confirmation'
    member do
      get 'biographies'
      get 'avatars'
      get 'calendars'
    end
  end

  resources :languages, only: [:index]

  resources :warehouse_transactions, except: [:index]
  resources :warehouse_batches, only: [:show, :edit, :create, :update, :destroy] do
    collection do
      get :autocomplete
    end

    resources :warehouse_transactions, only: [:new, :index], path: :transactions
  end
  resources :warehouse_items, only: [:show, :edit, :create, :update, :destroy] do
    resources :warehouse_batches, only: [:new, :index], path: :batches
  end
  resources :warehouses do
    resources :warehouse_items, only: [:new, :index], path: :items
  end

  resources :tags do
    collection do
      post :populate
    end
  end

  get 'taggeds/:item/:id' => "taggeds#edit", as: :edit_tags
  patch 'taggeds/:item/:id' => "taggeds#update", as: :update_tags

  resources :talks do
    member do
      get 'archive'
    end
  end

  resources :calendars do
    collection do
      get 'events'
      get 'talks'
      get 'user/talks', :action => :user_talks
      get 'user'
    end
    member do
      get 'events'
      get 'ical'
    end
  end

  resources :attachments do

  end

  resources :roles do
    member do
      post :set_default
    end

    collection do
      get 'edit_user/:user_id' => 'roles#edit_user_roles', as: :edit_user
      patch 'user/:user_id' => 'roles#update_user_roles', as: :update_user
    end
  end

  resource :geo do
    resources :cities
    resources :countries
    resources :continents
  end

  resources :teams do

    resources :members, :controller => :team_members, :as => :team_members

    resources :attendee_types do
      post 'default'
    end

    resources :event_types do
      post 'default'
    end

    resources :expense_types do
      post 'default'
    end

    member do
      get 'select'
      get 'settings'
    end

    collection do
      get 'statistics'
      get 'slack'
      get 'slack/sync', :action => :slack_sync

      resources :invitations, :controller => :team_invitations, :as => :team_invitations do
        member do
          get 'accept'
          get 'decline'
        end
      end
    end
  end

  post '/slack/:action', :controller => 'slack'

end
