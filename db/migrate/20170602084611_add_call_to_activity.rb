class AddCallToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :call, index: true, foreign_key: true
  end
end
