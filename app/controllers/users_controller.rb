class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def trim_users
    i=0
    y=0
    User.all.each do |u|
      if i > 100
        u.destroy
        y+=1
      end
      i+=1
    end

    render :text => "Deleted #{y} users"
  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.save

    redirect_to users_path
  end


  def show
  end


  def klout_score
    u = User.find(params[:id])
    puts "returning klout score #{u.klout_score} for user #{u.twitter_username}"
    render :text => u.klout_score
  end


end