require 'mongoid'

class User
  include Mongoid::Document
  field :first_name
  field :last_name
  field :email
  field :klout_score
  field :twitter_username


  def self.transfer_to_mongo(users)
    users.each do |u|
      name = u.name.split(" ")
      name[1] = "" if name[1].nil?

      new_user = User.find_or_create_by(twitter_username: u.screen_name)
      new_user.first_name = name[0]
      new_user.last_name = name[1]
      new_user.twitter_username = u.screen_name

      puts "saving user #{u.screen_name}"

      new_user.save
    end

    users.count
  end
  
end