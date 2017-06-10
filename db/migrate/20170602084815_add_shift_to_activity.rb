class AddShiftToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :shift, index: true, foreign_key: true
  end
end
