class AddOfficeToClients < ActiveRecord::Migration
  def change
    add_reference :clients, :office, index: true, foreign_key: true
  end
end
