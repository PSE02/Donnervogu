class HomeController < ApplicationController
   require 'rubygems'
   
   #grants access to the methods only for logged in user
   before_filter :require_user

   def index
   end

   def setHtml
       set = params[:set]
       @fc = FileCreator.new
       @fc.createNewZip((set))
   end
end
