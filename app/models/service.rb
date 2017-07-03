class Service < ActiveRecord::Base
  validates_presence_of :service

  belongs_to :user
  belongs_to :call
  belongs_to :shift

end
