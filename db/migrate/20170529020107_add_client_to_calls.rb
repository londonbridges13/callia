class AddClientToCalls < ActiveRecord::Migration
  def change
    add_reference :calls, :client, index: true, foreign_key: true
  end
end
