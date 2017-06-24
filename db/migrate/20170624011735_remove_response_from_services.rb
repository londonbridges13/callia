class RemoveResponseFromServices < ActiveRecord::Migration
  def change
    remove_column :services, :response, :boolean
  end
end
