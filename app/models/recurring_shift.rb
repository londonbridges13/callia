class RecurringShift < ActiveRecord::Base
  validates_presence_of :frequency
  validates_presence_of :time_span
  validates_presence_of :days

  belongs_to :office
  has_one :shift

end
