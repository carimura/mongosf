class TwitterController < ApplicationController

  def index
    @users = User.all(sort: [[:klout_score, :desc]])
    @klout_count = User.count(conditions: { :klout_score.ne => nil })
    @klout_sw_count = User.count(conditions: { :klout_score_sw.ne => nil })
  end

  def twitter_friends
    @friends = @twitter.get_all_friends
  end


  def update_klout_serially
    t1 = Time.now

    users = User.all
    x=0
    users.each do |u|
      break if x > 10

      puts "Getting score for #{u.twitter_username}"
      u.get_klout_score

      x += 1
    end
    t2 = Time.now

    flash[:success] = "Klouts generated for #{x} users in #{t2 - t1} seconds"

    redirect_to :action => :index
  end

  def update_klout_parallel
    t1 = Time.now
    worker = KloutBatchQb.new
    worker.db_settings = MONGOID[Rails.env]
    worker.queue(:priority => 2)
    t2 = Time.now

    flash[:success] = "Workers Scheduled in #{t2 - t1} seconds"
    
    redirect_to :action => :index
  end


  def delete_klouts
    t1 = Time.now
    users = User.all
    x=0
    users.each do |u|
      x+=1
      #x<=1000 ? next : u.delete
      u.klout_score = nil
      u.klout_score_sw = nil
      u.save
    end
    t2 = Time.now

    flash[:success] = "Klouts deleted for #{users.count} users in #{t2 - t1} seconds"
    redirect_to :action => :index
  end


  def import_users
    @friends = @twitter.get_all_friends
    @followers = @twitter.get_all_followers

    t1 = Time.now
    @count = User.transfer_to_mongo(@friends)
    @count2 = User.transfer_to_mongo(@followers)
    t2 = Time.now

    flash[:success] = "#{@count + @count2} users copied to MongoDB in #{t2 - t1} seconds"
    redirect_to :action => :index
  end


end