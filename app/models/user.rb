require 'mongoid'

class User
  include Mongoid::Document
  field :first_name
  field :last_name
  field :email
  field :klout_score
  field :klout_score_sw

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

  def get_klout_score
    api_keys = ["zegbm6n2438q6xuna4knnwnz", "jxhxgvpxnqyyen534xv49fqp", "kyjeda7yc4umc6c9xez4a8h7"]
    begin
      # Get the score!!
      key = api_keys[rand(3)]
      
      response = RestClient.get 'http://api.klout.com/1/klout.json', {:params => {:key => key, :users => self.twitter_username}}
      parsed = JSON.parse(response)
      score = parsed["users"][0]["kscore"] #if parsed["users"] && parsed["users"][0]
      self.klout_score = score
      self.save
      puts "Found Score --> #{score}"
    rescue => ex
      puts "Exception for #{self.twitter_username}:  #{ex.inspect}"
    end
  end

end