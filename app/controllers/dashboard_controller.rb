class DashboardController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  def index
    unless current_user
      redirect_to :controller => 'landing', :action => 'index'
    end

    if current_user
      current_user.set_basic_services #if user just registered, create basic services for the calls

      @number = "No Number"
      number = current_user.call_number
      if number
        if number[0...2] == "+1"
          @number = number[2...number.length]
        end
        @number = "("+@number[0...3]+") "+@number[3...6]+"-"+@number[6...number.length]
      end
    end

    call_logs # display calls for the data table
    if @calls.count > 0
      graph_clock_in
      graph_clock_out
    else
      @clock_outs = 0
      @clock_ins = 0
      hours = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[8,0],[9,0],[10,0],[11,0],[12,0],
      [13,0],[14,0],[15,0],[16,0],[17,0],[18,0],[19,0],[20,0],[21,0],[22,0],[23,0],[24,0]]
      @cin_hours = hours
      @cout_hours = hours
    end
  end

  def call_logs #reports/call_logs

    @calls = Call.where(user: current_user).where("created_at > ?", Time.now - 24.hours).reverse
  end

  def graph_clock_in
    hours = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[8,0],[9,0],[10,0],[11,0],[12,0],
    [13,0],[14,0],[15,0],[16,0],[17,0],[18,0],[19,0],[20,0],[21,0],[22,0],[23,0],[24,0]]
    start = Date.today.beginning_of_day
    the_end = Date.tomorrow.beginning_of_day
    calls = Call.where(log_type: "Clocked In").where(user: current_user).where('created_at BETWEEN ? AND ?', start, the_end)
    calls.each do |c|
      hour = c.created_at.strftime("%H").to_i
      hours[hour - 1][1] += 1 # add 1 to call count
      p hours
    end
    @cin_hours = hours
    @clock_ins = calls.count
  end

  def graph_clock_out
    hours = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[8,0],[9,0],[10,0],[11,0],[12,0],
    [13,0],[14,0],[15,0],[16,0],[17,0],[18,0],[19,0],[20,0],[21,0],[22,0],[23,0],[24,0]]
    start = Date.today.beginning_of_day
    the_end = Date.tomorrow.beginning_of_day
    calls = Call.where(log_type: "Clocked Out").where(user: current_user).where('created_at BETWEEN ? AND ?', start, the_end)
    calls.each do |c|
      hour = c.created_at.strftime("%H").to_i
      hours[hour - 1][1] += 1 # add 1 to call count
      p hours
    end
    @cout_hours = hours
    @clock_outs = calls.count
  end

  def return_call_array(calls)
    hours = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[8,0],[9,0],[10,0],[11,0],[12,0],
    [13,0],[14,0],[15,0],[16,0],[17,0],[18,0],[19,0],[20,0],[21,0],[22,0],[23,0],[24,0]]

    calls.each do |c|
      p "below is c"
      p c
      hour = c.to_time.strftime("%H").to_i
      p c.to_time
      p hour
      hours[hour - 1][1] += 1 # add 1 to call count
      p hours
    end
    return hours
  end

  helper_method :return_call_array

  def get_the_hour(time)
    # scrap the string for the hour and then reuturn the hour
  end

  def get_time_difference(time1, time2)
    p time1
    p time2
    time_diff = TimeDifference.between(time1, time2).in_hours
    p "time difference: #{time_diff}"
    p @time_diff
    return time_diff
  end
  helper_method :get_time_difference

end
