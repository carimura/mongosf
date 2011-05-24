class KloutBatchWorker < SimpleWorker::Base

  merge "../models/user"

  attr_accessor :users, :db_settings

  def run
    log "Running Klout Batch Worker"
    init_mongohq

    #log "Found users --> #{users.inspect} "

    users.each do |u|
      log "Getting score for #{u["twitter_username"]}"
      get_klout_score(u["twitter_username"])
    end
  end


  def get_klout_score(username, retries=0)
    api_keys = ["zegbm6n2438q6xuna4knnwnz", "jxhxgvpxnqyyen534xv49fqp", "kyjeda7yc4umc6c9xez4a8h7", "wyxy6q2k23k9vth3z7akpm4t"]
    begin
      response = RestClient.get 'http://api.klout.com/1/klout.json', {:params => {:key => api_keys[rand(4)], :users => username}}
      parsed = JSON.parse(response)

      score = parsed["users"][0]["kscore"] #if parsed["users"] && parsed["users"][0]

      u = User.first(conditions: {twitter_username: username})
      u.klout_score_sw = score
      u.save
      log "Found Score --> #{score}"
    rescue => ex
      log "Exception for #{username}:  #{ex.inspect}"
      sleep 1
      return if retries > 5
      retries += 1
      get_klout_score(username, retries)
    end
  end


  def init_mongohq
    Mongoid.configure do |config|
      config.database = Mongo::Connection.new(db_settings["host"], db_settings["port"]).db(db_settings["database"])
      config.database.authenticate(db_settings["username"], db_settings["password"])
      config.persist_in_safe_mode = false
    end
  end

end