class TwitterController < ApplicationController

  def index
    @users = User.all(sort: [[:klout_score, :desc]])
  end

  def twitter_friends
    @friends = @twitter.get_all_friends
  end


  def update_klout_serially
    t1 = Time.now

    users = User.all

    x=0
    users.each do |u|
      #break if x > 10

      # No twitter name, no need for this user
      u.delete if u.twitter_username.nil?

      puts "Getting score for #{u.twitter_username}"
      u.get_klout_score

      x += 1
    end

    t2 = Time.now

    flash[:success] = "Klouts generated for #{x} users in #{t2 - t1} seconds"

    redirect_to :action => :index
  end

  def update_klout_parallel
    worker = KloutBatchQb.new
    worker.db_settings = MONGOID[Rails.env]
    worker.queue(:priority => 2)

    flash[:success] = "Parallel running"
    redirect_to :action => :index
  end


  def delete_klouts
    t1 = Time.now
    users = User.all
    users.each do |u|
      u.klout_score = nil
      u.save
    end
    t2 = Time.now

    flash[:success] = "Klouts deleted for #{users.count} users in #{t2 - t1} seconds"
    redirect_to :action => :index
  end


  def import_users
    @friends = @twitter.get_all_friends

    t1 = Time.now
    @count = User.transfer_to_mongo(@friends)
    t2 = Time.now

    flash[:success] = "#{@count} users copied to MongoDB in #{t2 - t1} seconds"
    redirect_to :action => :index
  end


end