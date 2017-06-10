class AddCaregiverToCalls < ActiveRecord::Migration
  def change
    add_reference :calls, :caregiver, index: true, foreign_key: true
  end
end
