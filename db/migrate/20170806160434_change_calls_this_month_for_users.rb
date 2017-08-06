class ChangeCallsThisMonthForUsers < ActiveRecord::Migration
  def change
    change_column :users, :calls_this_month, :integer, :default => 0
  end
end
