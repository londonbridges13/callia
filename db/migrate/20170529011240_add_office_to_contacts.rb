class AddOfficeToContacts < ActiveRecord::Migration
  def change
    add_reference :contacts, :office, index: true, foreign_key: true
  end
end
