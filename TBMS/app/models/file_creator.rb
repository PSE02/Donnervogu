require 'rubygems'
require 'hpricot'
require 'zip/zip' # rubyzip gem
require 'zip/zipfilesystem'
include StringstripperHelper

class FileCreator < ActiveRecord::Base
	def createNewZip isSet
		zipPath = Dir.pwd + "/public/profiles/profile.zip"
		Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) do
			|zipfile|
			zipfile.get_output_stream("user.js") { |f| f.puts getConfig(isSet) }  
		end
	end

	def getConfig isSet
		filecontent = htmlTag(isSet)
		return filecontent
	end

	def htmlTag isSet
		xmlPath = Dir.pwd + "/xmlTemplates/config.xml"
		fh = File.open(xmlPath, "r")
		htmlTag = "html" + isSet
 
		doc = Hpricot(fh)
		htmlContent = (doc/htmlTag).inner_html
		htmlContent = strip(htmlContent)
		return htmlContent
	end

end


