class Shift < ActiveRecord::Base
  validates_presence_of :start_time
  validates_presence_of :end_time
  validates_presence_of :duration

  belongs_to :office
  belongs_to :client
  belongs_to :caregiver
  belongs_to :recurring_shift
  has_one :calls #should we have multiple calls for the same shift when everything on it will be the same?
  # We'll be using multiple calls to track the amount of calls that a person makes (to charge properly).
  # I handle this so we can go with it (Use one).
  has_many :activities

  # user created shift
    def save_activity(text, user, shift)
      activity = Activity.new(activity:text)
      activity.user = user
      activity.shift = shift
      activity.save
    end

end
