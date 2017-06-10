class AddCaregiverToContact < ActiveRecord::Migration
  def change
    add_reference :contacts, :caregiver, index: true, foreign_key: true
  end
end
