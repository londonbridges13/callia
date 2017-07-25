class AddEndRecurrenceDateToRecurringShifts < ActiveRecord::Migration
  def change
    add_column :recurring_shifts, :end_recurrence_date, :datetime
  end
end
