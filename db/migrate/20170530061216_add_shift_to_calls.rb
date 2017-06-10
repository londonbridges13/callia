class AddShiftToCalls < ActiveRecord::Migration
  def change
    add_reference :calls, :shift, index: true, foreign_key: true
  end
end
