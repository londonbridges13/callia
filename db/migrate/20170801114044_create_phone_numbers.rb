class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.string :number
      t.boolean :is_used

      t.timestamps null: false
    end
  end
end
