class RemoveAgencyTelephoneFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :agency_telephone, :integer
    add_column :users, :agency_telephone, :string
  end
end
