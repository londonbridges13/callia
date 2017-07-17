class AddClockOutCallIdToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :clock_out_call_id, :integer
    add_column :calls, :clock_in_call_id, :integer
  end
end
