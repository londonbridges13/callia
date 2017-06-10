class Client < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :authorized_phone

  belongs_to :office
  belongs_to :user
  has_many :calls
  has_many :shifts
  has_one :contact
  has_many :activities


  def set_code(office, user)
    unless self.client_code and self.client_code.length > 2
      # get all codes
      all_codes = []
      office.clients.each do |o|
        all_codes.push o.client_code
      end
      done = false
      while done == false
        code = 3.times.map { rand(1..9) }.join.to_i
        if all_codes.include? code
          done = false
        else
          done = true
        end
      end
      self.client_code = code
      self.save

      # and set user
      self.user = user
      self.save
    end
  end

# user created client
  def save_activity(text, user, client)
    activity = Activity.new(activity:text)
    activity.user = user
    activity.client = client
    activity.save
  end

end
