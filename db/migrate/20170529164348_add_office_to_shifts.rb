class AddOfficeToShifts < ActiveRecord::Migration
  def change
    add_reference :shifts, :office, index: true, foreign_key: true
  end
end
