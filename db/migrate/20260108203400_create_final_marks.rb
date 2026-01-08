class CreateFinalMarks < ActiveRecord::Migration[8.0]
  def change
    create_table :final_marks do |t|
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.references :assignment, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.references :assignment_group_score, null: false, foreign_key: true
      t.decimal :score, precision: 5, scale: 2, null: false
      t.datetime :calculated_at

      t.timestamps
    end

    add_index :final_marks, [:student_id, :assignment_id], unique: true, name: "idx_fm_on_student_and_assignment"
    add_index :final_marks, :assignment_id, name: "idx_fm_on_assignment_id"
    add_index :final_marks, :group_id, name: "idx_fm_on_group_id"
    add_index :final_marks, :assignment_group_score_id, name: "idx_fm_on_ags_id"
  end
end

