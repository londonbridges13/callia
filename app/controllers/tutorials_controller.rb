class TutorialsController < ApplicationController

  def index
  end
  def quickstart
  end
  def quickstart_step2
  end
  def quickstart_step3
  end

  def terms_and_conditions
  end

  def demo_explained
    something = params[:anything]
    demo_office = Office.all.where(user: current_user).where("name like ?", "%(Demo Office)%").first
    unless demo_office
      @office = Office.new(name: "(Demo Office)")
      @office.user = current_user
      @office.save
    end
    if something
      #CREATE IF AND ONLY IF USER DOESNT HAVE DEMO CAREGIVER AND DEMO CLIENT
      @name = something[:name]
      unless @name
        message = "Please enter a your name"
        redirect_to "/demo?message=#{message}"
      else
        # Create Caregiver from name
        @caregiver = Caregiver.new(name: "#{@name} (Demo Caregiver)")
        @caregiver.user = current_user
        @caregiver.office = @office
        demo_caregiver = Caregiver.all.where(user: current_user).where("name like ?", "%(Demo Caregiver)%").first
        unless demo_caregiver
          @caregiver.save
          @caregiver.set_code(@caregiver.office)
          @caregiver.set_user(current_user)
          @demo_caregiver = Caregiver.all.where(user: current_user).where("name like ?", "%(Demo Caregiver)%").first
        end
        unless @demo_caregiver
          @demo_caregiver = demo_caregiver
        end

        @telephone = something[:telephone]
        unless @telephone
          message = "Please enter a your phone number"
          redirect_to "/demo?message=#{message}"
        else
          #create Client from telephone
          @client = Client.new(name: "Demo Client", authorized_phone: @telephone)
          #add essential properties
          @client.user = current_user
          @client.office = @office
          demo_client = Client.all.where(user: current_user).where("name like ?", "%Demo Client%").first
          unless demo_client
            unless @client.save
              # redirect back because the client didn't save
              message = "Please enter a another phone number. This number is already used for a Client."
              redirect_to "/demo?message=#{message}"
            else
              #when if saves
              @client.set_code(@client.office, current_user)
            end
          end
        end
      end


    end
  end

  def demo
    unless current_user.call_number
      add_phone_number_to_user
    end
    @message = params[:message]

    if current_user.offices.count == 0
      @office = Office.new(name: "(Demo Office)")
      @office.user = current_user
      @office.save
    end
  end

  def start_guide
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
      else
        #email me to buy a number from twilio
        send_twilio_email
      end
    end
  end

  def send_twilio_email
    # using mailgun
    name = "Lyndon"
    email = "lyndonmckay@callia.us"
    mail = Mail.deliver do
      to      "#{email}" # change to self.email
      from    'Callia Support <serena@support.callia.us>'
      subject 'Callia needs more phone numbers'

      text_part do
        body "Hi #{name},\n"+
        "Callia is in need of new phone numbers for this increase in Callia members.\n\n" +
        "To add new numbers, go here\n\n" +
        "www.twilio.com \n" +
        "Thanks,\n" +
        "Serena"
      end
    end

  end
end
