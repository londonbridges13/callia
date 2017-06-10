class CreateRecurringShifts < ActiveRecord::Migration
  def change
    create_table :recurring_shifts do |t|
      t.integer :frequency
      t.string :time_span

      t.timestamps null: false
    end
  end
end
