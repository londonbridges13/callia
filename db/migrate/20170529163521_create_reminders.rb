class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :reminder
      t.datetime :date
      t.text :notes

      t.timestamps null: false
    end
  end
end
