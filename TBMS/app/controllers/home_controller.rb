class HomeController < ApplicationController
   require 'rubygems'
   
   #grants access to the methods only for logged in user
   before_filter :require_user

   def index
	   @users = User.all
   end

   def configureProfile
       html = params[:html]
       signature = params[:signature]  
       @fc = FileCreator.new
       @fc.createNewZip(html, signature )
   end
end
