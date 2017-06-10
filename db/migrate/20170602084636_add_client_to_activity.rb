class AddClientToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :client, index: true, foreign_key: true
  end
end
