require 'csv'
# Author:: Jonas Ruef, Dominique Rahm
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
  
  def upload
    file_param = params[:upload][:file]
    filename = file_param.original_filename
    filedata = file_param.read
    raise "filename nil" if filename.nil?
    raise "data nil" if filedata.nil?
    
    
    path = File.join(Dir.pwd, "public","uploads", filename)
    @a = File.new(path, "w+")
    @a.puts filedata
    csvimport(filedata)
  end
  
  #DR next step would be to add the groups (domain) if the do not exist and add each new Emailaccount to this group
  def csvimport filedata
    i = 0
    csv = CSV.parse(filedata)
    csv.delete_at(0)
    csv\
      .collect {|e| e[0]}\
        .each do |email|
          i = i + 1;
          @newAccount = Emailaccount.new
          @newAccount.email = email
          @newAccount.name = email.split(/@/)[0]
          @newAccount.save
        end
   #DR notice does not work!
     redirect_to(emailaccounts_url, :notice => "#{i} new Emailaccounts created from csv")
  end
end