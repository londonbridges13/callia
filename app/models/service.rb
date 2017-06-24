class Service < ActiveRecord::Base
  belongs_to :user
  belongs_to :call
  belongs_to :shift

end
