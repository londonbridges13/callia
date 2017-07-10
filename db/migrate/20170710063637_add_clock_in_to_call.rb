class AddClockInToCall < ActiveRecord::Migration
  def change
    add_column :calls, :clock_in, :datetime
  end
end
