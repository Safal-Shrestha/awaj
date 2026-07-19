# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.destroy_all

User.create!({
    :name => "Admin",
    :email => "admin@gmail.com",
    :role => "admin",
    :password => "admin05",
    :password_confirmation => "admin05"
})

5.times do |i|
    User.create!({
        :name => "Test User #{i+1}",
        :email => "user#{i+1}@gmail.com",
        :password => "password123",
        :password_confirmation => "password123"
    })
end

5.times do |i|
    Department.create(
        department_name: "Department #{i+1}",
        slug: "department-#{i+1}",
        description: "Description of Department #{i+1}"
    )
end