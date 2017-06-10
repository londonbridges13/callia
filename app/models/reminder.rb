class Reminder < ActiveRecord::Base
  validates_presence_of :reminder 

  belongs_to :user
end
