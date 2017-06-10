class Office < ActiveRecord::Base

  validates_presence_of :name
  # validates_presence_of :office_code # on me


  belongs_to :user
  has_one :location
  has_one :contact
  has_many :activities
  has_many :clients
  has_many :caregivers
  has_many :shifts
  has_one :supervisor, class_name: "Caregiver"

  # belongs_to :author, class_name: "User"

  def set_code(user)
    unless self.office_code and self.office_code.length > 2
      # get all codes
      all_codes = []
      user.offices.each do |o|
        all_codes.push o.office_code
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
      self.office_code = code
      self.save
      return office_code
    end
  end

# user created office
  def save_activity(text, office, user)
    activity = Activity.new(activity:text)
    activity.office = office
    activity.user = user
    activity.save
  end

  # user set office supervisor
    def set_supervisor_activity(text, office, user, employee)
      activity = Activity.new(activity:text)
      activity.caregiver = employee
      activity.office = office
      activity.user = user
      activity.save
    end
end
