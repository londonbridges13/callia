class AddUserToPhoneNumbers < ActiveRecord::Migration
  def change
    add_reference :phone_numbers, :user, index: true, foreign_key: true
  end
end
