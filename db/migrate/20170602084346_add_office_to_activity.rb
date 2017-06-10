class AddOfficeToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :office, index: true, foreign_key: true
  end
end
