# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.new({email:"admin@cm2opus.com", password:"gw", password_confirmation:"gw", reset_password_token: SecureRandom.uuid.gsub(/\-/,'')}).save(validate: false)