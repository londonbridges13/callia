class AddDaysToReccurringShifts < ActiveRecord::Migration
  def change
    add_column :recurring_shifts, :days, :string, array: true, default: '{}'
  end
end
