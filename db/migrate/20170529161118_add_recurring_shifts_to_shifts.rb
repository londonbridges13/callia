class AddRecurringShiftsToShifts < ActiveRecord::Migration
  def change
    add_reference :shifts, :recurring_shift, index: true, foreign_key: true
  end
end
