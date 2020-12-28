Rails.application.routes.draw do
  scope module: 'api', constraints: {subdomain: 'api'} do
    namespace :v1 do
      resources :instances
      resources :plans
    end
  end

  scope module: 'control_panel', constraints: {subdomain: 'cloud'} do
    root to: 'application#index'
    resources :sessions
    resources :confirmations
    get '/paddle/webhook' => 'api/v1/paddle#edit'
    post '/paddle/webhook' => 'api/v1/paddle#edit'
    get '/sessions/:provider/callback', to: 'sessions#create'
    get '/registrations/:provider/callback', to: 'registrations#create'
    get '/logins/:provider/callback', to: 'logins#create'
    get '/logout' => 'sessions#destroy'
    get '/login', to: 'application#login'
    get '/login/otp', to: 'application#login'
    get '/forgot/password', to: 'application#login'
    get '/register', to: 'application#register'
    get '/profile', to: 'application#index'
    get '/security-log', to: 'application#index'
    get '/cards', to: 'application#index'
    get '/projects', to: 'application#index'
    get '/projects/:project_id', to: 'application#tab_by_role'
    scope '/projects/:project_id' do
      resources :invoices
      get '', to: 'application#index'
      get '/vpcs', to: 'application#index'
      get '/vpcs/:id', to: 'application#index'
      get '/connectors', to: 'application#index'
      get '/members', to: 'application#index'
      get '/support', to: 'application#index'
      get '/notifications', to: 'application#index'
      get '/services', to: 'application#index'
      get '/services/new', to: 'application#index'
      get '/api', to: 'application#index'
      get '/billing', to: 'application#index'
      get '/project', to: 'application#index'
      get '/audit-log', to: 'application#index'
      get '/services/:id', to: redirect('/projects/%{project_id}/services/%{id}/settings')
      scope '/services/:id' do
        get '/edit', to: 'application#index'
        get '/metrics', to: 'application#index'
        get '/nodes', to: 'application#index'
        get '/settings', to: 'application#index'
        get '/snapshots', to: 'application#index'
        get '/events', to: 'application#index'
        get '/jobs', to: 'application#index'
        get '/firewall', to: 'application#index'
        get '/log', to: 'application#index'
      end
    end

    namespace :api do
      namespace :v1 do
        resources :contacts
        resources :invitations
        resources :logins
        resources :sessions
        resources :pusher
        resources :plans
        resources :users
        resources :security_logs
        resources :passwords
        resources :vpcs, only: :index
        resources :datacenters, only: :index
        resources :otp do
          collection do
            post :enable
            delete :disable
            post :confirm
            post :recovery_codes
          end
        end
        resources :projects do
          resources :paddle
          resources :audit_logs
          resources :tickets
          resources :members
          resources :access_keys
          resources :billing
          resources :cloud_profiles
          resources :virtual_networks do
            resources :peers
          end
          resources :instances do
            resources :nodes, :tasks, :metrics, :logs, :snapshots, :events
          end
        end
      end
    end

    get '/*path', to: 'application#not_found'
  end
end
