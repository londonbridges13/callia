class ApplicationController < ActionController::Base
  # before_filter :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_filter :return_errors, only: [:page_not_found, :server_error]

  def page_not_found
       @status = 404
       @layout = "application"
       @template = "not_found_error"
  end

  def server_error
     @status = 500
     @layout = "error"
     @template = "internal_server_error"
  end

   def after_sign_in_path_for(resource)
     "/"
   end

   protected

   def configure_permitted_parameters
     devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :agency_name, :agency_website, :agency_telephone, :payroll,:time_zone,:current_password])
     devise_parameter_sanitizer.permit(:account_update, keys: [:name, :agency_name, :agency_website, :agency_telephone, :payroll,:time_zone])
   end

   private

   def return_errors
       respond_to do |format|
             format.html { render template: 'errors/' + @template, layout: 'layouts/' + @layout, status: @status }
             format.all  { render nothing: true, status: @status }
       end
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
