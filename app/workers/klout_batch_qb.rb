class KloutBatchQb < SimpleWorker::Base

  merge "../models/user"

  merge_worker "klout_batch_worker", "KloutBatchWorker"

  attr_accessor :db_settings

  def run
    log "Running Klout Batch Quarterback!"
    init_mongohq
    
    users = User.all
    users_chunk = []

    i=0
    users.each do |u|
      i>=31 ? break : i+=1
      
      log "Adding user #{u.twitter_username}"
      users_chunk << u.twitter_username

      if users_chunk.size % 10 == 0
        log "Creating worker with #{users_chunk.inspect}"

        kbw = KloutBatchWorker.new
        kbw.users = users_chunk
        kbw.queue

        users_chunk = []
      end
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