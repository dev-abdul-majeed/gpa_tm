class CreateCoursesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.references :teacher, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    create_table :course_students, id: false do |t|
      t.belongs_to :course, foreign_key: true
      t.belongs_to :student, foreign_key: { to_table: :users }
    end
    
    add_index :courses, [:teacher_id, :name], unique: true
  end
end
