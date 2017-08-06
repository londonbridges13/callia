class RemoveFreeCallsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :free_calls, :integer
  end
end
