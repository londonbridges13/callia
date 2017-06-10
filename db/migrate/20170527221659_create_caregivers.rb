class CreateCaregivers < ActiveRecord::Migration
  def change
    create_table :caregivers do |t|
      t.string :name
      t.string :employee_code
      t.string :address
      t.string :city
      t.string :state
      t.string :status
      t.date :birth_date

      t.timestamps null: false
    end
  end
end
