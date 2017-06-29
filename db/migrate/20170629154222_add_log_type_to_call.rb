class AddLogTypeToCall < ActiveRecord::Migration
  def change
    add_column :calls, :log_type, :string
  end
end
