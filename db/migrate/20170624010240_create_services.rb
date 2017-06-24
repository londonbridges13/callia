class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.text :service
      t.boolean :response

      t.timestamps null: false
    end
  end
end
