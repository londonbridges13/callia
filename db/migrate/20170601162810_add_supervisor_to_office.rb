class AddSupervisorToOffice < ActiveRecord::Migration
  def change
    add_reference :offices, :supervisor, foreign_key: { to_table: :caregivers }
  end
end
