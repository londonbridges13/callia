class AddInitialRecordedVoiceToCaregiver < ActiveRecord::Migration
  def change
    add_column :caregivers, :initial_recorded_voice, :string
  end
end
