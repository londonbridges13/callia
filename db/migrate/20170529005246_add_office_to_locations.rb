class AddOfficeToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :office, index: true, foreign_key: true
  end
end
