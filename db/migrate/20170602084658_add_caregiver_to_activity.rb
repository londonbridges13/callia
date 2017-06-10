class AddCaregiverToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :caregiver, index: true, foreign_key: true
  end
end
