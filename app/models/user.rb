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
        "Did you assisst with bathing the patient?",
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

    end
  end


end
