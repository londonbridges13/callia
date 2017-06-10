class Call < ActiveRecord::Base

  belongs_to :user
  belongs_to :client
  belongs_to :caregiver
  belongs_to :shift
  has_one :activity


# caregiver has made call from client's phone, check for shift
  def save_activity(text, call, client, caregiver)
    activity = Activity.new(activity:text)
    activity.client = client
    activity.caregiver = caregiver

    #check for shift
    if call.shift
      activity.shift = call.shift
    end

    activity.save
    count_calls
  end

  def count_calls
    # set the call to the user incharge so that we know who to pay
    if self.client
      # link from client
      user = self.client.office.user
      if user
        # add call to user
        user.calls = self
      end
    elsif self.caregiver
      # link from client
      user = self.caregiver.office.user
      if user
        # add call to user
        user.calls = self
      end
    end
  end

end
