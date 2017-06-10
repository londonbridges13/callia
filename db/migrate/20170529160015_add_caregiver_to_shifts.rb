class AddCaregiverToShifts < ActiveRecord::Migration
  def change
    add_reference :shifts, :caregiver, index: true, foreign_key: true
  end
end
