class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :caller_number
      t.string :called_number

      t.timestamps null: false
    end
  end
end
