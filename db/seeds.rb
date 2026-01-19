puts "Dropping existing records..."

FinalMark.destroy_all
AssignmentGroupScore.destroy_all
PeerMarkSubmission.destroy_all
PeerMark.destroy_all
Group.destroy_all
Assignment.destroy_all
Course.destroy_all
Teacher.destroy_all
Student.destroy_all
Admin.destroy_all
SuperAdmin.destroy_all
School.destroy_all

puts "✅ Finished dropping records"

puts "Creating SuperAdmin..."
SuperAdmin.create!(
  email: 'sa@example.com',
  password: '123456',
  password_confirmation: '123456',
  first_name: 'Super',
  last_name: 'Admin',
  gender: 'Male',
  date_of_birth: '2000-01-01'
)
puts "✅ SuperAdmin created"

puts "Seeding schools..."
School.create!([
  {
    name: "University of Northampton",
    location: "Northampton, UK",
    domain: "northampton.ac.uk"
  },
  {
    name: "Oakwood International School",
    location: "Manchester, UK",
    domain: "oakwood.ac.uk"
  },
  {
    name: "Maple Tree Academy",
    location: "Birmingham, UK",
    domain: "mapletreeacademy.org"
  }
])
puts "✅ Finished seeding schools"

northampton_school = School.find_by(name: "University of Northampton")

puts "Creating Admin for University of Northampton..."
Admin.create!(
  email: 'admin@example.com',
  password: '123456',
  password_confirmation: '123456',
  first_name: 'School',
  last_name: 'Admin',
  gender: 'Male',
  date_of_birth: '1990-01-01',
  school_id: northampton_school.id
)
puts "✅ Admin created"

puts "Creating Teachers for University of Northampton..."
teachers_data = [
  { first_name: 'John', last_name: 'Doe', email: 'jd@example.com', gender: 'Male' },
  { first_name: 'Ahmed', last_name: 'Ali', email: 'aa@example.com', gender: 'Male' },
  { first_name: 'Sarah', last_name: 'Smith', email: 'ss@example.com', gender: 'Female' },
  { first_name: 'Fatima', last_name: 'Hassan', email: 'fh@example.com', gender: 'Female' },
  { first_name: 'Michael', last_name: 'Brown', email: 'mb@example.com', gender: 'Male' }
]

teachers_data.each do |teacher_data|
  Teacher.create!(
    email: teacher_data[:email],
    password: '123456',
    password_confirmation: '123456',
    first_name: teacher_data[:first_name],
    last_name: teacher_data[:last_name],
    gender: teacher_data[:gender],
    date_of_birth: '1985-01-01',
    school_id: northampton_school.id
  )
end
puts "✅ Teachers created"

puts "Creating Students for University of Northampton..."
students_data = [
  { first_name: 'Alice', last_name: 'Anderson', gender: 'Female' },
  { first_name: 'Bilal', last_name: 'Ahmed', gender: 'Male' },
  { first_name: 'Charlie', last_name: 'Clark', gender: 'Male' },
  { first_name: 'Dua', last_name: 'Khan', gender: 'Female' },
  { first_name: 'Emma', last_name: 'Evans', gender: 'Female' },
  { first_name: 'Faisal', last_name: 'Ibrahim', gender: 'Male' },
  { first_name: 'Grace', last_name: 'Green', gender: 'Female' },
  { first_name: 'Hassan', last_name: 'Mohammed', gender: 'Male' },
  { first_name: 'Isabella', last_name: 'Jones', gender: 'Female' },
  { first_name: 'Jamal', last_name: 'Rahman', gender: 'Male' },
  { first_name: 'Kate', last_name: 'King', gender: 'Female' },
  { first_name: 'Layla', last_name: 'Malik', gender: 'Female' },
  { first_name: 'Matthew', last_name: 'Miller', gender: 'Male' },
  { first_name: 'Noor', last_name: 'Ali', gender: 'Female' },
  { first_name: 'Oliver', last_name: 'Owen', gender: 'Male' },
  { first_name: 'Patricia', last_name: 'Parker', gender: 'Female' },
  { first_name: 'Qasim', last_name: 'Hussain', gender: 'Male' },
  { first_name: 'Rachel', last_name: 'Roberts', gender: 'Female' },
  { first_name: 'Samuel', last_name: 'Scott', gender: 'Male' },
  { first_name: 'Tariq', last_name: 'Yusuf', gender: 'Male' },
  { first_name: 'Uma', last_name: 'Upton', gender: 'Female' },
  { first_name: 'Victoria', last_name: 'Vance', gender: 'Female' },
  { first_name: 'William', last_name: 'Wilson', gender: 'Male' },
  { first_name: 'Xavier', last_name: 'Xie', gender: 'Male' },
  { first_name: 'Yasmin', last_name: 'Ahmed', gender: 'Female' },
  { first_name: 'Zainab', last_name: 'Hassan', gender: 'Female' }
]

students_data.each_with_index do |student_data, index|
  email = "#{('a'.ord + index).chr}@example.com"
  Student.create!(
    email: email,
    password: '123456',
    password_confirmation: '123456',
    first_name: student_data[:first_name],
    last_name: student_data[:last_name],
    gender: student_data[:gender],
    date_of_birth: '2000-01-01',
    school_id: northampton_school.id
  )
end
puts "✅ Students created"

puts "✅ Finished seeding database"
