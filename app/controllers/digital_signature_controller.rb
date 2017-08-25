require 'twilio-ruby'

class DigitalSignatureController < ApplicationController



  def employee_code #1

  end

  def confirm #2
    something = params[:anything]
    if something
      @code = something[:code]
      @caregivers = Caregiver.all.where(:employee_code => "#{@code}")
    end
  end

  def verify #3
    # send a text to this number to verify number
    id = params[:id]
    @id = params[:id]
    caregiver = Caregiver.all.where(id: id).first
    @code = send_text(caregiver)

    # caregiver should enter the number to verify

  end

  def select_client
    # make sure to send the caregiver info for the user
    id = params[:id]
    verify = params[:verify]
    code = params[:anything][:code]
    caregiver = Caregiver.all.where(id: id).first

    @company_name = caregiver.office.user.agency_name
    unless code == verify
      #redirect to invalid page
      redirect_to "/verify?id=#{id}"
    end
    caregiver = Caregiver.all.where(id: id).first
    @clients = caregiver.user.clients

  end

  def timesheet #4
    id = params[:id]
    @id = params[:id]
    # verify = params[:verify]
    # code = params[:anything][:code]
    caregiver = Caregiver.all.where(id: id).first

    # @company_name = caregiver.office.user.agency_name
    # unless code == verify
    #   #redirect to invalid page
    #   redirect_to "/verify?id=#{id}"
    # end
    #display the timesheet form and verify location

    if params[:client_id]
      get_client_location
    end

  end

  def send_text(c)
    #send caregiver a text to verify themselves
    if c.phone_number and c.user
      #send text
      p "sending text"

      client = Twilio::REST::Client.new(
        ENV['TWILIO_ACCOUNT_SID'], #set these two
        ENV['TWILIO_AUTH_TOKEN']
      )
      code = 5.times.map { rand(1..9) }.join.to_i

      client.messages.create(
        from: "#{c.user.call_number}",
        to: "#{c.phone_number}",
        body: "Verification code: #{code}"
      )
      return code
    else
      p "not sending text"
      p "#{c.phone_number} | #{c.user}"
    end
  end

  def get_client_location
    client = Client.find_by_id(params[:client_id])
    @client = client

    res = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{client.address} #{client.city},  #{client.state}"

    @client_lat = res.latitude
    @client_long = res.longitude
  end

  def verify_location
    id = params[:id]
    @id = id
    caregiver = Caregiver.all.where(id: id).first
    @count = 0

    if params[:client_id]
      get_client_location
    end


  end

  def verified_location
    p @count
    if @count == 1
      redirect_to :action => "timesheet", client_id: @client.id, id: @id
    end
    @count = 1
    p @count

  end
  helper_method :verified_location

  def update_timesheet
    # create call, save services to the call, save caregiver and client to the call
    @timesheet = Call.new(call_params)

    if @timesheet.save
      redirect_to "/congrats"
    end
  end


  def service_params
    params.require(:service).permit(:service, :response)
  end

  def call_params
    params.require(:call).permit(:caller_number, :called_number, :service_ids, :order)
  end

end
