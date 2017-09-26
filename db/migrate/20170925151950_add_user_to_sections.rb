class AddUserToSections < ActiveRecord::Migration
  def change
    add_reference :sections, :user, index: true, foreign_key: true
  end
end
