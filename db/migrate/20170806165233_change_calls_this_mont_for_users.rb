class ChangeCallsThisMontForUsers < ActiveRecord::Migration
  def change
    change_column :users, :calls_this_month, :integer, :default => 0, :null => false
  end
end
