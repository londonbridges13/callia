class DashboardController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  def index
    unless current_user
      redirect_to :controller => 'landing', :action => 'index'
    end

    if current_user
      @number = "No Number"
      number = current_user.call_number
      if number[0...2] == "+1"
        @number = number[2...number.length]
      end
      @number = "("+@number[0...3]+") "+@number[3...6]+"-"+@number[6...number.length]
    end
  end



end
