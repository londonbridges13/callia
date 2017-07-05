class AddDurationToCall < ActiveRecord::Migration
  def change
    add_column :calls, :duration, :string
  end
end
