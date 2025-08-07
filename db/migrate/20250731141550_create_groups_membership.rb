class CreateGroupsMembership < ActiveRecord::Migration[8.0]
  def change
    create_table :group_memberships do |t|
      t.references :group, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    
    # Ensure one student can only be in one group per course
    add_index :group_memberships, [:student_id, :group_id], unique: true
    
    # Could also add a database level constraint
   
  end
end
