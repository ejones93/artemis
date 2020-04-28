# Create a main sample user.
User.create!(name:  "Example User", 
			 email: "emlynjones93@gmail.com", 
			 password: "foobar", 
			 password_confirmation: "foobar", 
			 admin: true,
			 activated: true,
			 activated_at: Time.zone.now)

# Generate a bunch of additional users.
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name, 
			   email: email, 
			   password: password, 
			   password_confirmation: password,
			   activated: true,
			   activated_at: Time.zone.now)
end

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end