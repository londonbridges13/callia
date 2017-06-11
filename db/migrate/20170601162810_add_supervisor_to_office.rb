class AddSupervisorToOffice < ActiveRecord::Migration
  def change
    # add_reference :offices, :supervisor, foreign_key: { to_table: :caregivers }
    change_table :offices do |o|
      o.references :supervisor, references: :caregiver #-> foo_bar_store_id
    end
  end

end
