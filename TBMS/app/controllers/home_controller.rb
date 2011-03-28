class HomeController < ApplicationController
   require 'rubygems'
   
   #grants access to the methods only for logged in user
   before_filter :require_user

   def index
	   @users = User.all
	   redirect_to(emailaccounts_path)
   end

   def configureProfile
   end
end
