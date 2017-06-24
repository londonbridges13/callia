class AddResponseToServices < ActiveRecord::Migration
  def change
    add_column :services, :response, :string
  end
end
