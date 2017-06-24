class AddShiftToServices < ActiveRecord::Migration
  def change
    add_reference :services, :shift, index: true, foreign_key: true
  end
end
