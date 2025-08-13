class CreateAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :assignments do |t|
      t.string :title, limit: 50, null: false
      t.string :type, null: false
      t.integer :rating_scale, default: 0, null: false
      t.string :rating_model, default: 'B'
      t.boolean :calibration, default: false
      t.datetime :start_date_time
      t.datetime :end_date_time
      t.decimal :self_rating_weight, precision: 5, scale: 2, default: 0.0
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end

    add_index :assignments, :type
    add_index :assignments, :rating_scale
    add_index :assignments, :calibration
  end
end
