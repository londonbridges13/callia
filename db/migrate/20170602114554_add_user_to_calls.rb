class AddUserToCalls < ActiveRecord::Migration
  def change
    add_reference :calls, :user, index: true, foreign_key: true
  end
end
