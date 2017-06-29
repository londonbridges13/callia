require 'twilio-ruby'

class CallsController < ApplicationController
  include Webhookable
  after_filter :set_header
  skip_before_action :verify_authenticity_token
  before_action :set_call, only: [:show, :edit, :update, :destroy, :get_employee, :verify_caller]



  def voice
    from = params['PhoneNumber']
  #  response = Twilio::TwiML::Response.new do |r|
    @call = Call.new
    @call.caller_number = params['From']
    @call.called_number = params['To']
    @call.save
    #  find_admin
    r.Say "Hey there, you've called #{params['To']}. Congrats on integrating Twilio into your Rails 4 app.", :voice => 'alice'
       r.Play 'http://linode.rabasa.com/cantina.mp3'
    # ask_for_employee_code
   end

   render_twiml response
  end

  def caregiver
    response = Twilio::TwiML::Response.new do |r|
      r.Gather finishOnKey: '*', action: planets_path do |g|
        g.Say "message fart", voice: 'alice', language: 'en-GB', loop:3
      end
    end
  end


  def find_caller
    caller_number = params['From']

    if caller_number[0...2] == "+1"
      caller_number = caller_number[2...caller_number.length]
    end

    client = find_client(caller_number)
    if client
      @call.client = client
      if client.user
        @call.user = client.user
      end
      @call.save
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
    message = "Welcome, enter your code to get started."

   response = Twilio::TwiML::Response.new do |r|
     r.Gather finishOnKey: '*', action: get_employee_path(id: @call.id) do |g|
       g.Say message, voice: 'alice', language: 'en-GB', loop:2
     end
   end

   render text: response.text
  end


  #get_employee_path
  def get_employee
    code = params[:Digits]

    employee = Caregiver.find_by_employee_code(code)

    if employee
      p "Found Employee from code. #{code}. #{employee.name}"
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Found you, #{employee.name}. Is this correct?", :voice => 'alice'
        # more here
        #verify
        r.Gather finishOnKey: '*', action: verify_caller_path(id: @call.id) do |g|
          g.Say "Found you, #{employee.name}. Is this correct?", :voice => 'alice' loop:2
        end
        #once verified, record name (record_voice)

      end
      render text: response.text

      @call.caregiver = employee
      @call.save
    else
      p "Couldn't find Employee from code. #{code}"
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Couldn't find Employee with code: #{code}", :voice => 'alice'
        ask_for_employee_code #asking again because employee might have entered wrong number
      end
      render text: response.text
    end

    define_call_type

  end

  def verify_caller # verify_caller_path
    # 1 for yes, record voice and you're done
    # 2 for no, ask for code again

    user_selection = params[:Digits]

    case user_selection
    when "1"
      record_voice
    when "2"
      ask_for_employee_code
    else
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Invalid response, Good bye.", :voice => 'alice'
        r.Hangup
      end
      render text: response.text
    end
  end

  def record_voice
    # record the caller's voice as they say their name.
    #save recordingUrl

    response = Twilio::TwiML::Response.new do |r|
      r.Say "Please say your name after the beep.", :voice => 'alice'
      r.Record :maxLength => '5', action: play_voice_path
    end
    render text: response.text
  end

  def play_voice
    Twilio::TwiML::Response.new do |r|
      r.Say 'Listen to your voice.'
      r.Play params['RecordingUrl']
      r.Say 'Successfully Clocked In. Thank you, Goodbye.'
      r.Hangup
    end
    render text: response.text

  end

  def define_call_type(employee)
    #clock in or clock out
    last_call = Call.where(employee: employee).order("created_at").last

    if last_call and last_call.log_type == "Clocked In"
      # run clocked out
      clock_out
    else
      #run clocked in
      clock_in
    end
  end

  def clock_out
    # ask for services completed
    # then save log_type, thank them and be done
    ask_for_services

    @call.log_type = "Clocked Out"
    @call.save
  end

  def clock_in
    # save call time let user know they have successfully logged in
    @call.log_type = "Clocked In"
    @call.save

    response = Twilio::TwiML::Response.new do |r|
      r.Say "Succefully Clocked In. Thank you, #{@call.employee.name} and have a great day. Good bye.", :voice => 'alice'
      r.Hangup
    end
    render text: response.text
  end

  def ask_for_services
    #ask if employee completed each service

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
      params.require(:call).permit(:caller_number, :called_number)
    end
end
