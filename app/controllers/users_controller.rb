# Author:: Jonas Ruef
# Manages the users
class UsersController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :show
  
  # Creates a new empty user
  def new
    @user = User.new
  end

  # Setting up the user
  def create
    @user = User.new(params[:user])
    
    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @user.save
      redirect_to root_path
    else
      render :action => :new
    end
    
  end
  
  # Show the user and his statistics
  def show
    @user = current_user
  end
end