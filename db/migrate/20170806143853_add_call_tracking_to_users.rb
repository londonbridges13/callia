class AddCallTrackingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :calls_this_month, :integer
    add_column :users, :free_calls, :integer
    add_column :users, :next_billing_date, :datetime

  end
end
