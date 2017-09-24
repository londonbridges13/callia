class AddSectionToService < ActiveRecord::Migration
  def change
    add_column :services, :section, :string
  end
end
