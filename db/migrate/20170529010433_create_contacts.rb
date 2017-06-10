class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :email
      t.string :mobile_number
      t.string :home_number
      t.text :notes

      t.timestamps null: false
    end
  end
end
