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
    caregiver = Caregiver.all.where(id: id).first
    @code = send_text(caregiver)

    # caregiver should enter the number to verify

  end

  def timesheet #4
    id = params[:id]
    @id = params[:id]
    verify = params[:verify]
    code = params[:code]
    caregiver = Caregiver.all.where(id: id).first

    unless code == params
      #redirect to invalid page
      redirect_to "/verify?id=#{id}"
    end
    #display the timesheet form and verify location

  end

  def send_text(c)
    #send caregiver a text to verify themselves
    if c.phone_number and c.user
      #send text

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
    end
  end




end
