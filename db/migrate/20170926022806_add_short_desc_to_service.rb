class AddShortDescToService < ActiveRecord::Migration
  def change
    add_column :services, :short_desc, :string
  end
end
