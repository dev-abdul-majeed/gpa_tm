class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :group_name, null: false
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :groups, [:course_id, :group_name], unique: true
  end
end
