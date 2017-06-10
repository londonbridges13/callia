class Activity < ActiveRecord::Base

  belongs_to :office
  belongs_to :client
  belongs_to :caregiver
  belongs_to :shift
  belongs_to :user
  belongs_to :call

  def save_activity(text, office, user)
    activity = Activity.new(activity:text)
    activity.office = office
    activity.user = user
    activity.save
  end
end
