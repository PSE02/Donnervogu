class ApplicationController < ActionController::Base
  protect_from_forgery
  def index
  end

   def setHtml
       set = params[:set]
       @fc = FileCreator.new
       @fc.createNewZip((set))
   end
end
