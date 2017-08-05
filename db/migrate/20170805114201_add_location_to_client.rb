class AddLocationToClient < ActiveRecord::Migration
  def change
    add_column :clients, :location, :string
    add_column :clients, :address, :string
    add_column :clients, :postcode, :string
    add_column :clients, :state, :string
    add_column :clients, :city, :string
  end
end
