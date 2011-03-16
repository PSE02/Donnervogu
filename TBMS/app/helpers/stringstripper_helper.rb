module StringstripperHelper

	def strip string
		return string.gsub(/\t/, "").sub(/\n/, "") # Strips the string of tabs and the first new line
	end

end
