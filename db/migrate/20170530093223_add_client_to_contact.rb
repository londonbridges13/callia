class AddClientToContact < ActiveRecord::Migration
  def change
    add_reference :contacts, :client, index: true, foreign_key: true
  end
end
