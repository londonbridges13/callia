class AddUserToOffices < ActiveRecord::Migration
  def change
    add_reference :offices, :user, index: true, foreign_key: true
  end
end
