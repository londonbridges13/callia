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
    @id = params[:id]
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
    id = params[:c_id]
    @id = params[:c_id]
    # verify = params[:verify]
    # code = params[:anything][:code]
    caregiver = Caregiver.all.where(id: id).first
    @caregiver = caregiver

    client = Client.find_by_id(params[:client_id])
    @client = client
    # @company_name = caregiver.office.user.agency_name
    # unless code == verify
    #   #redirect to invalid page
    #   redirect_to "/verify?id=#{id}"
    # end
    #display the timesheet form and verify location

    # if params[:client_id]
    #   get_client_location
    # end

    # @timesheet = Call.new
    # @timesheet.log_type = "Timesheet: Incomplete"
    # @timesheet.user = caregiver.user
    # @timesheet.caregiver = caregiver
    # @timesheet.client = client
    # @timesheet.save
    # set_services
    # @services = @timesheet.services


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

    @timesheet.log_type = "Digital Timesheet: Completed"
    if @timesheet.save
      redirect_to "/congrats"
    end
  end

  def set_services
    # use in the timesheet func
    @service_ids = []
    @caregiver.user.services.each do |s|
      service = Service.new
      service.service = s.service
      service.save
      @timesheet.services.push service# don't set the service.user, that is for the user to tweak only
      @service_ids.push s.id
    end

    @services = @timesheet.services
    @t_id = @timesheet.id
    if @service_ids[0] #should be 0
      @question = Service.find_by_id(@service_ids[0]).service
    end

  end


  def display_question

    order = params[:order].to_i
    @order = order

    id = params[:c_id].to_i
    @id = params[:c_id].to_i #caregiver id

    caregiver = Caregiver.all.where(id: id).first
    @caregiver = caregiver

    client = Client.find_by_id(params[:client_id])
    @client = client

    @t_id = params[:t_id].to_i #timesheet id
    if @t_id
      @timesheet = Call.find_by_id(@t_id)
    end
    t_id = @t_id
    @service_ids = []#params[:service_ids]
    if params[:service_ids]
      params[:service_ids].tr('[]', '').split(',').map(&:to_i).each do |n|
        @service_ids.push n.to_i
      end
    end

    response = params[:response]

    if response
      # Set answer, go to next question
      service = Service.find_by_id(@service_ids[order])
      p @service_ids
      p params[:service_ids]
      p @service_ids[order]
      p service

      if service
        service.response = response
        unless @timesheet.services.include? service
          @timesheet.services.push service
        end
        service.save
      end

      @next_url = "/display_question?client_id=#{client.id}&c_id=#{@id}&order=#{order + 1}&t_id=#{@t_id}&service_ids=#{@service_ids}"
      redirect_to @next_url
    else
      # display_question
      @timesheet = Call.find_by_id(@t_id)

      if order > 0 and @t_id and @timesheet
        t_id = @t_id

        if @service_ids[order] #test, DOESNT WORK
          @question = Service.find_by_id(@service_ids[order]).service

          @next_url = "/display_question?client_id=#{client.id}&c_id=#{@id}&order=#{order + 1}&t_id=#{@t_id}&service_ids=#{@service_ids}"
        else
          # done, redirect to timesheet
          redirect_to "/timesheet?client_id=#{@timesheet.client.id}&c_id=#{@timesheet.caregiver.id}"
        end
      else
        # order == 0
        # create timesheet here then continue to display the first question
        # send t_id through, send order through

        @timesheet = Call.new
        @timesheet.log_type = "Timesheet: Incomplete"
        @timesheet.save
        @timesheet.user = caregiver.user
        @timesheet.save
        @timesheet.caregiver = caregiver
        @timesheet.client = client
        @timesheet.save

        set_services

      end
    end
  end

  def service_params
    params.require(:service).permit(:service, :response)
  end

  def call_params
    params.require(:call).permit(:caller_number, :called_number, :service_ids, :order)
  end

end
