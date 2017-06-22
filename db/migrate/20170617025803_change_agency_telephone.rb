class ChangeAgencyTelephone < ActiveRecord::Migration
  def change
     remove_column :users, :agency_telephone
     add_column :users, :agency_telephone, :integer
  end
end
