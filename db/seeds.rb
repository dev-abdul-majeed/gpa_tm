
# SuperAdmin.create!(
#   email: 'sa@gmail.com',
#   password: '123456',
#   password_confirmation: '123456',
#   first_name: 'Super',
#   last_name: 'Admin',
#   gender: 'Male',
#   date_of_birth: '2000-01-01'
# )


puts "Seeding schools..."
begin
  School.create!([
    {
      name: "Green Valley High School",
      location: "London, UK",
      domain: "gv.edu.uk"
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
    },
    {
      name: "Riverdale Grammar School",
      location: "Leeds, UK",
      domain: "riverdalegrammar.edu"
    }
  ])
rescue => exception
  puts "FAILED SCHOOL CREATION AGAIN"
end

puts "✅ Finished seeding schools!"
puts "Seeding Users...."

begin
  User.create([
    {email: 'student.1@gmail.com', first_name: 'student', last_name: '.1', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'Student', school_id: 1},
    {email: 'student.2@gmail.com', first_name: 'student', last_name: '.2', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'Student', school_id: 1},
    {email: 'student.3@gmail.com', first_name: 'student', last_name: '.3', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'Student', school_id: 1},
    {email: 'student.4@gmail.com', first_name: 'student', last_name: '.4', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'Student', school_id: 1},
    {email: 'student.4@gmail.com', first_name: 'student', last_name: '.4', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'Student', school_id: 1},
    {email: 'teacher.1@gmail.com', first_name: 'teacher', last_name: '.1', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'Teacher', school_id: 1},
    {email: 'teacher.2@gmail.com', first_name: 'teacher', last_name: '.3', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'Teacher', school_id: 1},
    {email: 'teacher.3@gmail.com', first_name: 'teacher', last_name: '.4', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'Teacher', school_id: 1},
    {email: 'teacher.4@gmail.com', first_name: 'teacher', last_name: '.5', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'Teacher', school_id: 1},
    {email: 'super.admin@gmail.com', first_name: 'Super', last_name: 'Admin', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'SuperAdmin', school_id: 1},
    {email: 'school.admin@gmail.com', first_name: 'School', last_name: 'Admin', gender: 'Male', date_of_birth: Date.today, password: '123456789', type: 'Admin', school_id: 1},
  ])
rescue => exception
  puts "FAILED CREATING SAME USERS again"
end

puts "✅ Finished seeding users"
