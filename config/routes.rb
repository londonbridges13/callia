Rails.application.routes.draw do

  # Added by Koudoku.
  mount Koudoku::Engine, at: 'koudoku'
  scope module: 'koudoku' do
    get 'pricing' => 'subscriptions#index', as: 'pricing'
  end


  resources :services
  resources :activities
  resources :settings
  resources :reminders
  resources :recurring_shifts
  resources :shifts
  resources :clients
  resources :contacts
  resources :offices do
    collection do
      get :show_telephone
    end
  end

  devise_for :users
  resources :caregivers
  resources :calls
  resources :dashboard
  resources :agency_details
  resources :reports
  resources :landing
  resources :schedule

  #All Routes
  get "caregivers/show"
  post 'calls/voice' => 'calls#voice'
  match 'calls/get_employee' => 'calls#get_employee', via: [:get, :post], as: 'get_employee'
  match 'calls/verify_caller' => 'calls#verify_caller', via: [:get, :post], as: 'verify_caller'
  match 'calls/play_voice' => 'calls#play_voice', via: [:get, :post], as: 'play_voice'
  match 'calls/clock_out' => 'calls#clock_out', via: [:get, :post], as: 'clock_out'
  match 'calls/clock_in' => 'calls#clock_in', via: [:get, :post], as: 'clock_in'
  match 'calls/ask' => 'calls#ask', via: [:get, :post], as: 'ask'
  match 'calls/answer' => 'calls#answer', via: [:get, :post], as: 'answer'
  match 'calls/ask_for_employee_code' => 'calls#ask_for_employee_code', via: [:get, :post], as: 'ask_for_employee_code'
  # get '*path' => redirect('/')
  get 'display_client' => "clients#display_client"
  get 'call_logs' => "reports#call_logs", as: 'call_logs'

  #User Paths

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get "/signup"   => "devise/registrations#new"
    get 'login', to: 'devise/sessions#new'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
