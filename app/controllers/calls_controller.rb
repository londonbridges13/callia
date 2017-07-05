require 'twilio-ruby'

class CallsController < ApplicationController
  include Webhookable
  after_filter :set_header
  skip_before_action :verify_authenticity_token
  before_action :set_call, only: [:show, :edit, :update, :destroy, :get_employee, :verify_caller,
    :clock_out, :clock_in, :play_voice, :ask_for_employee_code, :ask, :answer]



  def voice
    from = params['PhoneNumber']
    # response = Twilio::TwiML::Response.new do |r|
    @call = Call.new
    @call.caller_number = params['From']
    @call.called_number = params['To']
    @call.log_type = "Unsuccessful"
    @call.save
    find_admin
    find_caller
  #     r.Say "Hey there, you've called #{params['To']}. Congrats on integrating Twilio into your Rails 4 app.", :voice => 'alice'
  #        r.Play 'http://linode.rabasa.com/cantina.mp3'
    ask_for_employee_code
  #  end

  #  render_twiml response
  end


  def find_caller
    caller_number = params['From']

    if caller_number[0...2] == "+1"
      caller_number = caller_number[2...caller_number.length]
    end

    client = find_client(caller_number)
    if client
      p "Have a Client with the number: #{params['From']}. It's #{client.name}"
      @call.client = client
      if client.user
        @call.user = client.user
      end
      @call.save
    else
      p "No Client with this number: #{params['From']}"
    end
  end

  def clean_the_number(phone_number)
    # remove whitespaces, ")", etc
    phone_number.slice!(")")
    phone_number.slice!(" ")
    phone_number.slice!("(")
    phone_number.slice!("-")
    return phone_number
  end

  def find_client(caller_number)
    client = nil
    clients = Client.all
    clients.each do |c|
      # change client's number from (314) 708-9391 to 3147089391
      # then check with caller number
      c_number = clean_the_number(c.authorized_phone)
      if c_number == caller_number
        client = c
      end
    end
    if client
      p "Found Client. Client is #{client.name}"
      return client
    else
      p "Couldn't find Client for the caller's number"
      return nil
    end
  end

  def find_admin # the user who moniters this account
    number = params["To"]
    @user = User.find_by_call_number(number)
    if @user
      @call.user = @user
    end
  end

  def ask_for_employee_code
    message = "Welcome, please enter your code to get started, then press pound."

   response = Twilio::TwiML::Response.new do |r|
     r.Gather finishOnKey: '#', action: get_employee_path(id: @call.id) do |g|
       g.Say message, voice: 'alice'
     end
   end

   render text: response.text
  end


  #get_employee_path
  def get_employee
    code = params[:Digits]

    employee = Caregiver.find_by_employee_code(code)

    if employee
      @call.caregiver = employee
      if @call.caregiver.user
        @call.user = @call.caregiver.user
      end
      @call.save

      p "Found Employee from code. #{code}. #{employee.name}"
      response = Twilio::TwiML::Response.new do |r|
        # r.Say "Found you, #{employee.name}. Is this correct?", :voice => 'alice'
        # more here
        #verify
        r.Gather finishOnKey: '#', action: verify_caller_path(id: @call.id) do |g|
          g.Say "Found you, #{employee.name}. Is this correct? Press 1 for yes and 2 for no.", :voice => 'alice'

        end
        #once verified, record name (record_voice)

      end
      render text: response.text

      # @call.caregiver = employee
      # @call.save

      # define_call_type(employee)
    else
      p "Couldn't find Employee from code. #{code}"
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Couldn't find Employee with code: #{code}", :voice => 'alice', action: ask_for_employee_code_path(id: @call.id)
         #asking again because employee might have entered wrong number
      end
      render text: response.text
    end

  end

  def verify_caller # verify_caller_path
    # 1 for yes, determine whether clock in or clock out
    # 2 for no, ask for code again

    user_selection = params[:Digits]

    case user_selection
    when "1"
      define_call_type#record_voice
    when "2"
      ask_for_employee_code
    else
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Invalid response, Try again.", :voice => 'alice'
        r.Hangup
      end
      render text: response.text
    end
  end

  def record_voice
    # record the caller's voice as they say their name.
    #save recordingUrl

    response = Twilio::TwiML::Response.new do |r|
      r.Say "Please say your name, then press pound", :voice => 'alice'
      r.Record :finishOnKey => '#', action: play_voice_path(id: @call.id)
    end
    render text: response.text

  end

  def play_voice #play_voice_path
    @call.log_type = "Clocked In"
    @call.save
    @call.recorded_voice = params['RecordingUrl']
    @call.save
    if @call.caregiver
      # set caregiver's initial recording (for comparisons)
      unless @call.caregiver.initial_recorded_voice
        @call.caregiver.initial_recorded_voice = params['RecordingUrl']
        @call.caregiver.save
      end
    end
    @call.save

    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Listen to your voice.', :voice => 'alice'
      r.Play params['RecordingUrl']
      r.Say 'Successfully Clocked In. Thank you, Goodbye.', :voice => 'alice'
      r.Hangup
    end
    render text: response.text
  end

  def define_call_type
    #clock in or clock out
    last_call = Call.where(caregiver: @call.caregiver).where(caller_number: @call.caller_number).where("log_type = 'Clocked In' OR log_type = 'Clocked Out'").order("created_at").reverse.first
    p "Printing Last call from this number and caregiver. #{last_call.log_type}"

    if last_call and last_call.log_type == "Clocked In"
      # run clocked out
      p "redirecting"
      clock_out
    else
      #run clocked in
      p "redirecting"
      clock_in
    end
  end

  def clock_out #clock_out_path, didn't use
    # ask for services completed
    # then save log_type, thank them and be done (in ask_for_services)
    ask_for_services

  end

  def clock_in #clock_in_path
    #record voice
    # save call time let user know they have successfully logged in
    record_voice
    # @call.log_type = "Clocked In"
    # @call.save

    # response = Twilio::TwiML::Response.new do |r|
    #   r.Say "Succefully Clocked In. Thank you, #{@call.caregiver.name} and have a great day. Good bye.", :voice => 'alice'
    #   r.Hangup
    # end
    # render text: response.text
  end

  def ask_for_services
    # create the services for the call
    p "ask_for_services"

    service_ids = []
    @call.caregiver.user.services.each do |s|
      service = Service.new
      service.service = s.service
      service.save
      @call.services.push service# don't set the service.user, that is for the user to tweak only
      # service_ids.push s.id
    end
    @call.services.each do |s|
      # add id to service_ids
      service_ids.push s.id
      p "Added: #{s.id}"
    end
    #Use the service_ids in the parameters

    #ask if employee completed each service

    ask(0,service_ids) #asking the first question

  end


  def ask(order = nil, service_ids = nil) #ask_path
    unless order
      order = params[order]
    end
    unless service_ids
      service_ids = []
      params[:service_ids].each do |n|
        service_ids.push n.to_i
      end
    end
    id = service_ids[order]
    p "Order: #{order}"
    p "Service Ids: #{service_ids}"
    p "The Service Id: #{id}"

    service = Service.find_by_id(id)
    if service
      response = Twilio::TwiML::Response.new do |r|
        r.Gather numDigits: '1', action: answer_path(id: @call.id, order: order, service_ids: service_ids) do |g|
          g.Say "#{service.service} 1 for yes and 2 for no.", voice: 'alice'
        end
      end
      render text: response.text
    else
      #you are finished with Clock out
      @call.log_type = "Clocked Out"
      @call.save

      response = Twilio::TwiML::Response.new do |r|
        r.Say "You've Succefully Clocked Out! Thank you and Goodbye.", :voice => 'alice'
      end
      render text: response.text
      save_duration

    end
  end

  def save_duration
    cin = Call.where(caregiver: @call.caregiver).where(caller_number: @call.caller_number).where("log_type = 'Clocked In'").order("created_at").reverse.first.created_at
    cout = @call.created_at

    time = ""
    h = (cout - cin) / 3600 # gets time in hours
    h_rounded = h.round # use this
    time = "#{h_rounded}:"
    # now get the minutes
    a = (cout - cin) / 3600
    r = a.round

    mm = 0
    if a > r
      mm = (a - r) * 60 #the minutes are left over
    else
      mm = (r - a) * 60#the minutes are left over
    end
    if mm > 1 #than minutes are greater than 1 minute use it
      if mm > 9
        time = time + "#{mm}"
      else
        time = time + "#{mm}0"
      end
    else
      time = time + "00"
    end

    @call.duration
    @call.save
    # return time
  end

  def answer #answer_path
    # answer the question and if there is another question ask
    service_ids = []#params[:service_ids]
    params[:service_ids].each do |n|
      service_ids.push n.to_i
    end
    p "Service Ids: #{service_ids}"
    order = params[:order].to_i
    p "Order: #{order}"
    id = service_ids[order]
    p "The Service Id: #{id}"

    service = Service.find_by_id(id)
    if service
      user_selection = params[:Digits]

      case user_selection
      when "1" #yes
        # save response change the order +1
        service.response = "Yes"
        service.save
        p "Saving Response as #{service.response}"
        order += 1
        ask(order, service_ids) #asking new question
      when "2" #no
        # save response change the order +1
        service.response = "No"
        service.save
        p "Saving Response as #{service.response}"
        order += 1
        ask(order, service_ids) #asking new question
      else
        # response = Twilio::TwiML::Response.new do |r|
        #   r.Say "That is not an option", :voice => 'alice'
          ask(order, service_ids)
        # end
        # render text: response.text
      end
    else
      @call.log_type = "Clocked Out"
      @call.save

      response = Twilio::TwiML::Response.new do |r|
        r.Say "You've Succefully Clocked Out! Goodbye.", :voice => 'alice'#, action: play_voice_path(id: @call.id)
      end
      render text: response.text
      save_duration
    end
  end

  # GET /calls
  # GET /calls.json
  def index
    @calls = Call.all
  end

  # GET /calls/1
  # GET /calls/1.json
  def show
  end

  # GET /calls/new
  def new
    @call = Call.new
  end

  # GET /calls/1/edit
  def edit
  end

  # POST /calls
  # POST /calls.json
  def create
    @call = Call.new(call_params)

    respond_to do |format|
      if @call.save
        record_call_activity
        format.html { redirect_to @call, notice: 'Call was successfully created.' }
        format.json { render :show, status: :created, location: @call }
      else
        format.html { render :new }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calls/1
  # PATCH/PUT /calls/1.json
  def update
    respond_to do |format|
      if @call.update(call_params)
        record_call_activity
        format.html { redirect_to @call, notice: 'Call was successfully updated.' }
        format.json { render :show, status: :ok, location: @call }
      else
        format.html { render :edit }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  def record_call_activity
    if @call.client and @call.caregiver
      if @call.shift and @call.shift.start_time # shift has just began, set status to Ongoing
        save_activity("#{@call.caregiver} called from #{@call.client}'s Home. #{@call.caregiver}'s shift began.",
       @call, @call.client, @call.caregiver)
      else
        save_activity("#{@call.caregiver} called from #{@call.client}'s Home. #{@call.caregiver}'s shift ended.",
       @call, @call.client, @call.caregiver)
      end
    end

    shift_for_call # create or update shift time
  end

  def shift_for_call
    # set or get the shift from the call
    if @call.shift
      #shift exists set end time and duration
      @call.shift.end_time = Time.now
      duration = (@call.shift.end_time - @call.shift.start_time) / 3600 # convert to hours
      if duration
        @call.shift.duration = duration
      end
      @call.shift.save
    else
      # nothing, create here
      shift = Shift.new()
      shift.start_time = Time.now
      shift.save
      @call.shift = shift
    end
  end


  # DELETE /calls/1
  # DELETE /calls/1.json
  def destroy
    @call.destroy
    respond_to do |format|
      format.html { redirect_to calls_url, notice: 'Call was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_call
      @call = Call.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_params
      params.require(:call).permit(:caller_number, :called_number, :service_ids, :order)
    end
end
