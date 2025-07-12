
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

puts "✅ Finished seeding schools!"
