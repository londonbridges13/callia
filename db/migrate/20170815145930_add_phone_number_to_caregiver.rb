class AddPhoneNumberToCaregiver < ActiveRecord::Migration
  def change
    add_column :caregivers, :phone_number, :string
  end
end
 
