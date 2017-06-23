class ApplicationController < ActionController::Base
  # before_filter :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?

   def after_sign_in_path_for(resource)
     "/"
   end

   protected

   def configure_permitted_parameters
     devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :agency_name, :agency_website, :agency_telephone, :payroll])
     devise_parameter_sanitizer.permit(:account_update, keys: [:name, :agency_name, :agency_website, :agency_telephone, :payroll])
   end



    def layout_by_resource
      if devise_controller? && resource_name == :user && action_name == "new"
        # Login
        "/layouts/login_2"
      else
        "application"
      end
    end
end
