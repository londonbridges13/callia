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

    res = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{client.address} #{client.postcode}"

    @client_lat = res.latitude
    @client_long = res.longitude
  end

  def verify_location(long,lat)
    # compare long/lat to the long/lat of the Client's address
    # The Caregiver must be at the Client's/Patient's Address in order to get money
    # 1 == true
    # 0 == false

    p "#{long}"
    p "#{lat}"
    return 1
  end


  def update_timesheet
    # create call, save services to the call, save caregiver and client to the call
  end



end
