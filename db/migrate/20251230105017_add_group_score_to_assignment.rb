class AddGroupScoreToAssignment < ActiveRecord::Migration[8.0]
  def change
    add_column :assignments, :group_score, :float, default: 0.80, null: false
  end
end
