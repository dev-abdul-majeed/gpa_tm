require "csv"

module Importers
  class TeacherImporter
    def initialize(file:, school:)
      @file = file
      @school = school
    end

    def import
      results = { success: 0, failed: 0, errors: [] }

      CSV.foreach(@file.path, headers: true) do |row|
        teacher_data = row.to_hash.symbolize_keys
        teacher = Teacher.new(teacher_data.merge(school: @school))

        if teacher.save
          results[:success] += 1
          puts "<==========  Teacher Saved: #{teacher.first_name} #{teacher.last_name}.  =========>"
        else
          results[:failed] += 1
          results[:errors] << { row: row.to_h, messages: teacher.errors.full_messages }
          puts "<==========  Error Teacher Not saved: #{teacher.first_name} #{teacher.last_name}, #{teacher.errors.full_messages}.  =========>"
        end
      end

      results
    end
  end
end
