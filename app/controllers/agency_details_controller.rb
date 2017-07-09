class AgencyDetailsController < ApplicationController
  before_filter :authenticate_user!

  def index
    # redirect_to edit_user_registration_path
    resource_name
    resource
    devise_mapping
  end

  def edit
    # redirect_to edit_user_registration_path
    resource_name
    resource
    devise_mapping
  end

  def update
    respond_to do |format|
      if current_user.update_attributes(user_params)
        format.html { redirect_to clients_url, notice: 'Client was successfully updated.' }
      else
        format.html { render "/failed" }
      end
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource = current_user
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def user_params
    params.require(:user).permit(:name, :agency_name, :agency_website, :agency_telephone, :payroll)
  end

end
