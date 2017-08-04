require 'mailgun'
class User < ActiveRecord::Base
# Added by Koudoku.
  has_one :subscription

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable




  has_one :location
  # accepts_nested_attributes_for :location

  has_many :offices
  has_many :clients
  has_many :caregivers
  has_many :reminders
  has_many :calls # easy query for payments
  has_many :services


  def first_name
    space_index = self.name.index(" ")
    if space_index and space_index > 2
      first_name = self.name[0...space_index]
      return first_name
    end
  end

  def set_basic_services
    #Create basic services
    if self.services.count == 0
      services = [
        "Did you wash dishes for the patient?",
        "Did you feed the patient?",
        "Did you assist with bathing the patient?",
        "Did you do light house keeping?",
        "Did you assisst patient with grooming?",
        "Did you do laundry?",
        "Did you prepare meal for patient?",
        "Did you remind patient to take medications?",
        "Did you help patient with mobility or transfer?"
      ]

      services.each do |s|
        service = Service.new
        service.service = s
        service.save
        self.services.push service
      end

      self.send_welcome_email #this should only happen once
    end
  end

  def send_welcome_email
    # using mailgun
    name = self.first_name
    email = self.email
    mail = Mail.deliver do
      to      "#{email}" # change to self.email
      from    'Serena Jay <serena@support.callia.us>'
      subject 'Welcome to Callia'

      text_part do
        body "Hi #{name},\n"+
        "Thanks for signing up. I'm so excited to get started.\n\n" +
        "To help you get going, I've added a link to a Quick Start Guide.\n\n" +
        "www.callia.us/quickstart \n" +
        "Callia is easy use and this Quick Start Guide is the perfect place to start!\n\n" +
        "Thanks,\n" +
        "Serena"
      end
    end

  end

  def send_simple_message

    RestClient.post "https://api.mailgun.net/v3/sandbox7df54b75c00741d7b09014408f57254e.mailgun.org",
    :from => "postmaster@sandbox7df54b75c00741d7b09014408f57254e.mailgun.org",
    :to => "lyndonmckay13@gmail.com",
    :subject => "Hello",
    :text => "Testing some Mailgun awesomness!"
  end

  def check_for_missed_clock_outs
    self.calls.where(log_type: "Clocked In").where("clock_out_call_id IS NULL").each do |c|
      if c.created_at < 16.hours.ago
        # this is a unusually long work duration, the caregiver must have forgot to clock out
        call = Call.new
        call.log_type = "Missed Clock Out"
        call.caregiver = c.caregiver
        call.client = c.client
        call.clock_in_call = c.id
        call.save
      end
    end
  end

end
