class Contact < ActiveRecord::Base

  # attr_accesible :office_id, :name

  belongs_to :office
  belongs_to :caregiver
  belongs_to :client


end
