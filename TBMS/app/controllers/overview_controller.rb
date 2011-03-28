class OverviewController < ApplicationController
  
  def index
    @emailaccounts = Emailaccount.all
  end
  
  def show
    @emailaccounts = Emailaccount.all
  end 
end
