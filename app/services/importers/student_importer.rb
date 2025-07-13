require "csv"

module Importers
  class StudentImporter
    def initialize(file:, school:)
      @file = file
      @school = school
    end

    def import
      results = { success: 0, failed: 0, errors: [] }

      CSV.foreach(@file.path, headers: true) do |row|
        student_data = row.to_hash.symbolize_keys
        student = Student.new(student_data.merge(school: @school))

        if student.save
          results[:success] += 1
          puts "<==========  Student Saved: #{student.first_name} #{student.last_name}.  =========>"
        else
          results[:failed] += 1
          results[:errors] << { row: row.to_h, messages: student.errors.full_messages }
          puts "<==========  Error student Not saved: #{student.first_name} #{student.last_name}, #{teacher.errors.full_messages}.  =========>"
        end
      end

      results
    end
  end
end
