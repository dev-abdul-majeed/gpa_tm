class CreateAssignmentGroupScores < ActiveRecord::Migration[8.0]
  def change
    create_table :assignment_group_scores do |t|
      t.references :assignment, null: false, foreign_key: true
      t.references :group, null: true, foreign_key: true
      t.decimal :group_score, precision: 5, scale: 2, null: false
      t.datetime :set_at

      t.timestamps
    end

    add_index :assignment_group_scores, [:assignment_id, :group_id], unique: true, name: "idx_ags_on_assignment_and_group"
    add_index :assignment_group_scores, :assignment_id, name: "idx_ags_on_assignment_id"
  end
end

