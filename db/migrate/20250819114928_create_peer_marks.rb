class CreatePeerMarks < ActiveRecord::Migration[8.0]
  def change
    create_table :peer_marks do |t|
      t.references :assignment, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.references :giver, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.integer :score, null: false

      t.timestamps
    end

    add_index :peer_marks, [:assignment_id, :giver_id, :receiver_id], unique: true, name: "index_peer_marks_on_assignment_giver_receiver"

    # Ensure score stays within a sensible range
    add_check_constraint :peer_marks, "score >= 0 AND score <= 100", name: "peer_marks_score_range"
  end
end
