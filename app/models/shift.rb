class Shift < ActiveRecord::Base
  validates_presence_of :start_time
  validates_presence_of :end_time
  # validates_presence_of :duration

  belongs_to :office
  belongs_to :client
  belongs_to :caregiver
  belongs_to :recurring_shift
  has_one :call #should we have multiple calls for the same shift when everything on it will be the same?
  # We'll be using multiple calls to track the amount of calls that a person makes (to charge properly).
  # I handle this so we can go with it (Use one).
  has_many :activities
  has_many :services

  # user created shift
    def save_activity(text, user, shift)
      activity = Activity.new(activity:text)
      activity.user = user
      activity.shift = shift
      activity.client = shift.client
      activity.save
    end

    def started_shift_activity(text, call, shift)
      activity = Activity.new(activity:text)
      activity.user = call.user
      activity.shift = shift
      activity.call = call
      activity.client = call.client
      activity.caregiver = call.caregiver
      activity.save
    end

    def set_duration
      if self.start_time and self.end_time
        time_diff = TimeDifference.between(self.start_time, self.end_time).in_minutes
        self.duration = time_diff
        self.save
      end
    end

end
