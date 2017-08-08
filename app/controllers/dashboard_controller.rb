class DashboardController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  def index
    # s = Subscription.new
    # s.load_plans
    unless current_user
      redirect_to :controller => 'landing', :action => 'index'
    end

    if current_user and current_user.subscription
      current_user.set_basic_services #if user just registered, create basic services for the calls

      @number = "No Number"
      number = current_user.call_number
      if number
        if number[0...2] == "+1"
          @number = number[2...number.length]
        end
        @number = "("+@number[0...3]+") "+@number[3...6]+"-"+@number[6...number.length]
        display_free_calls
      else
        #give the user a number
        add_phone_number_to_user
      end
    elsif current_user and (current_user.offices.count > 0 and current_user.caregivers.count > 0 and current_user.clients.count > 0)
      # there is a user logged in but they don't have a plan
      # send them to /pricing
      redirect_to "/pricing"

    elsif current_user and current_user.offices.count == 0
      # go to quickstart
      redirect_to "/quickstart"
    elsif current_user and current_user.caregivers.count == 0
      # go to quickstart
      redirect_to "/quickstart_step2"
    elsif current_user and current_user.clients.count == 0
      # go to quickstart
      redirect_to "/quickstart_step3"
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

  def display_free_calls
    if current_user.subscription
      sid = current_user.subscription.stripe_id
      if sid
        # user has subscription
        p "user has subscription"
        #get the plan id
        plan_id = Stripe::Customer.retrieve(sid).subscriptions.first.plan.id
        if plan_id
          find_free_calls(plan_id) # cost per call
        end
      end
    else
      p "User has no subscription or Missing Next Billing Date"
    end

  end

  def find_free_calls(plan_id)
    if current_user.calls_this_month and current_user.calls_this_month > 0
      if plan_id == "starter-plan-1599"
        free_calls = 25
      elsif plan_id == "standard-plan-2399"
        free_calls = 50
      elsif plan_id == "enterprise-plan-5999"
        free_calls = 250
      end
      if free_calls and current_user.calls_this_month
        free_calls_left = free_calls - current_user.calls_this_month
        unless free_calls_left > 0
          free_calls_left = 0
        end
        @free_calls_left = free_calls_left
      end
    end
  end

  def add_phone_number_to_user
    # this means that the user has signed up, selected a plan, and entered credit card info
    unless current_user.call_number
      number = PhoneNumber.where(is_used: false).first
      if number
        number.user_id = current_user.id
        current_user.call_number = number.number
        number.is_used = true
        number.save
        current_user.save

        #reload the page
        redirect_to "/"
      else
        #email me to buy a number from twilio

      end
    end
  end

  def call_logs #reports/call_logs
    start = Date.today.beginning_of_day
    the_end = Date.tomorrow.beginning_of_day
    @calls = Call.where(user: current_user).where('created_at BETWEEN ? AND ?', start, the_end).reverse
  end

  def graph_clock_in
    hours = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[8,0],[9,0],[10,0],[11,0],[12,0],
    [13,0],[14,0],[15,0],[16,0],[17,0],[18,0],[19,0],[20,0],[21,0],[22,0],[23,0],[24,0]]
    start = Date.today.beginning_of_day
    the_end = Date.tomorrow.beginning_of_day
    calls = Call.where(log_type: "Clocked In").where(user: current_user).where('created_at BETWEEN ? AND ?', start, the_end)
    calls.each do |c|
      if current_user.time_zone
        hour = c.created_at.in_time_zone(current_user.time_zone).strftime("%H").to_i
      else
        hour = c.created_at.in_time_zone("Central Time (US & Canada)").strftime("%H").to_i
      end
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
      if current_user.time_zone
        hour = c.created_at.in_time_zone(current_user.time_zone).strftime("%H").to_i
      else
        hour = c.created_at.in_time_zone("Central Time (US & Canada)").strftime("%H").to_i
      end
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
      hour = c.to_time.localtime.strftime("%H").to_i
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
