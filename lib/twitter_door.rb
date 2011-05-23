class TwitterDoor

  def initialize
    @client = Twitter::Client.new
  end

  def get_all_friends
    friends = @client.friends({:cursor => -1})
    all_friends = []
    friends.users.each { |u| all_friends << u }

    while friends.next_cursor != 0
      friends = @client.friends(:cursor => friends.next_cursor)
      friends.users.each { |u| all_friends << u }
    end

    all_friends
  end

  def get_rate_limit
    @client.rate_limit_status.remaining_hits.to_s
  end

end