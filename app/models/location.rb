class Location < ActiveRecord::Base
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :postcode


  belongs_to :user
  belongs_to :office


end
