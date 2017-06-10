class AddClientToShifts < ActiveRecord::Migration
  def change
    add_reference :shifts, :client, index: true, foreign_key: true
  end
end
