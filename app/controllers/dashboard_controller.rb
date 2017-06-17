class DashboardController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  def index
    unless current_user
      redirect_to :controller => 'landing', :action => 'index'
    end
  end


end
