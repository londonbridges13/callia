class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :first_name
      t.boolean :allow_reminder_for_birthdays

      t.timestamps null: false
    end
  end
end
