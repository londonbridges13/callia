class AddOfficeToCaregivers < ActiveRecord::Migration
  def change
    add_reference :caregivers, :office, index: true, foreign_key: true
  end
end
