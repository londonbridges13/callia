class Caregiver < ActiveRecord::Base
  validates_presence_of :name
  # validates_presence_of :employee_code

  belongs_to :office
  belongs_to :user
  has_one :contact
  has_many :calls
  has_many :shifts
  has_many :activities

  # scope :user_caregivers, -> (id) { includes(:caregivers).where(user_id: id) }


  def set_code(office)
    unless self.employee_code and self.employee_code.length > 2
      # get all codes
      all_codes = []
      office.caregivers.each do |o|
        all_codes.push o.employee_code
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
      self.employee_code = code
      self.save
    end
  end

  def set_user(user)
    self.user = user
    self.save
  end

# user created caregiver
  def save_activity(text, user, caregiver)
    activity = Activity.new(activity:text)
    activity.user = user
    activity.caregiver = caregiver
    activity.save
  end

end
