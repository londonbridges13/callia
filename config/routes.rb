Rails.application.routes.draw do

  devise_for :admins
  resources :phone_numbers
  # Added by Koudoku.
  mount Koudoku::Engine, at: 'koudoku'
  scope module: 'koudoku' do
    get 'pricing' => 'subscriptions#index', as: 'pricing'
  end


  resources :tutorials
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

  # devise_for :users
  resources :caregivers
  resources :calls
  resources :dashboard
  resources :reports
  resources :landing
  resources :schedule
  resources :digital_signature

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
  post 'call_logs' => "reports#call_logs", as: 'search_call_logs'
  get 'timecard_report' => "reports#timecard_report", as: 'timecard_report'
  post 'timecard_report' => "reports#timecard_report", as: 'search_timecard_report'
  get 'activity_report' => "reports#activity_report", as: 'activity_report'
  post 'activity_report' => "reports#activity_report", as: 'search_activity_report'
  get 'custom_prompt_report' => "reports#custom_prompt_report", as: 'custom_prompt_report'
  post 'custom_prompt_report' => "reports#custom_prompt_report", as: 'search_custom_prompt_report'
  get 'evv_recording' => "reports#evv_recording", as: 'evv_recording'
  post 'evv_recording' => "reports#evv_recording", as: 'search_evv_recording'
  # post 'search_call_logs' => 'reports#search_call_logs', as: 'search_call_logs'
  #User Paths
  get 'quickstart' => "tutorials#quickstart", as: 'quickstart'
  get 'quickstart_step2' => "tutorials#quickstart_step2", as: 'quickstart_step2'
  get 'quickstart_step3' => "tutorials#quickstart_step3", as: 'quickstart_step3'
  get 'terms_and_conditions' => "tutorials#terms_and_conditions", as: 'terms_and_conditions'
  # digital_signature
  match 'digital_signature/confirm' => 'digital_signature#confirm', via: [:get, :post], as: 'confirm'
  match 'digital_signature/select_client' => 'digital_signature#select_client', via: [:get, :post], as: 'select_client'
  match 'display_question' => 'digital_signature#display_question', via: [:get, :post], as: 'display_question'
  # match 'digital_signature/timesheet' => 'digital_signature#timesheet', via: [:get, :post], as: 'timesheet'
  # get 'confirm' => "digital_signature#confirm", as: 'confirm'
  get 'employee_code' => "digital_signature#employee_code", as: 'employee_code'
  get 'verify' => "digital_signature#verify", as: 'verify'
  get 'timesheet' => "digital_signature#timesheet", as: 'timesheet'
  # get 'display_question' => "digital_signature#display_question", as: 'display_question'
  get 'verify_location' => "digital_signature#verify_location", as: 'verify_location'
  put 'update_timesheet', to: 'digital_signature#update_timesheet', as: "update_timesheet"
  get 'congrats' => "digital_signature#congrats", as: 'congrats'

  # get 'select_client' => "digital_signature#select_client", as: 'select_client'

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get "/signup"   => "devise/registrations#new"
    get 'login', to: 'devise/sessions#new'
    get 'agency_details', to: 'devise/registrations#edit'
    put 'update_agency', to: 'users/registrations#update', as: "update_agency"

  end

  devise_for :users, controllers: {
      registrations: 'users/registrations'
  }

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
