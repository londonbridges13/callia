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
    @message = params[:message]
  end

end
