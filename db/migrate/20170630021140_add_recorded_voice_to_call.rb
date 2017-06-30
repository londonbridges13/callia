class AddRecordedVoiceToCall < ActiveRecord::Migration
  def change
    add_column :calls, :recorded_voice, :string
  end
end
