class KloutBatchWorker < SimpleWorker::Base

  attr_accessor :users

  def run
    log "Running Klout Batch Worker with users --> #{users.inspect}!"

    users.each do |u|
      log "Found user #{u}!"
    end
  end



  
end