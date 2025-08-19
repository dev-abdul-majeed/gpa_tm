class CreatePeerMarkSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :peer_mark_submissions do |t|
      t.references :assignment, null: false, foreign_key: true
      t.references :giver, null: false, foreign_key: { to_table: :users }
      t.boolean :submitted, default: false, null: false
      t.datetime :submitted_at

      t.timestamps
    end

    add_index :peer_mark_submissions, [:assignment_id, :giver_id], unique: true, name: "index_peer_mark_submissions_on_assignment_and_giver"
  end
end
