class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :client_code
      t.string :authorized_phone
      t.string :status

      t.timestamps null: false
    end
  end
end
