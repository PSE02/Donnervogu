class HomeController < ApplicationController
 	def index
	end

	def setHtml
		set = params[:set] 
		if set == "true"
			redirect_to("http://www.google.com")
		else
			redirect_to("http://www.web.de")
		end
	end
end
