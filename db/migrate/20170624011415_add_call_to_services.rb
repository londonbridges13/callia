class AddCallToServices < ActiveRecord::Migration
  def change
    add_reference :services, :call, index: true, foreign_key: true
  end
end
