class CreateSchools < ActiveRecord::Migration[8.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :location
      t.string :domain

      t.timestamps
    end
  end
end
