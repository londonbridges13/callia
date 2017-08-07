class AddLocationToOffices < ActiveRecord::Migration
  def change
    add_column :offices, :location, :string
    add_column :offices, :address, :string
    add_column :offices, :postcode, :string
    add_column :offices, :state, :string
    add_column :offices, :city, :string
  end
end
