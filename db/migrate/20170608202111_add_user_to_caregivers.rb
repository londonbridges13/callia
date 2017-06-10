class AddUserToCaregivers < ActiveRecord::Migration
  def change
    add_reference :caregivers, :user, index: true, foreign_key: true
  end
end
