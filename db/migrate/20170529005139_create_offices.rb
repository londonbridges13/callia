class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.string :name
      t.string :telephone
      t.string :office_code

      t.timestamps null: false
    end
  end
end
