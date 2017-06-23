require 'twilio-ruby'

class CallsController < ApplicationController
  include Webhookable
  after_filter :set_header
  skip_before_action :verify_authenticity_token
  before_action :set_call, only: [:show, :edit, :update, :destroy]



  def voice
   from = params['PhoneNumber']
   response = Twilio::TwiML::Response.new do |r|
     r.Say 'Hey there from '+ from + '. Congrats on integrating Twilio into your Rails 4 app.', :voice => 'alice'
        r.Play 'http://linode.rabasa.com/cantina.mp3'
   end

   render_twiml response
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
