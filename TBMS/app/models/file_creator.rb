require 'rubygems'
require 'hpricot'
require 'zip/zip' # rubyzip gem
require 'zip/zipfilesystem'

include StringstripperHelper

class FileCreator < ActiveRecord::Base
	def createNewZip html, signatur
		zipPath = Dir.pwd + "/public/profiles/profile.zip"
		Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) do
			|zipfile|
			zipfile.get_output_stream("user.js") { |f| f.puts getConfig(html) }  
		end
	end

	def getConfig html
		filecontent = htmlTag(html)
		return filecontent
	end

	def htmlTag html
		xmlPath = Dir.pwd + "/xmlTemplates/config.xml"
		fh = File.open(xmlPath, "r")
		htmlTag = "html" + html
		doc = Hpricot(fh)
		htmlContent = (doc/htmlTag).inner_html
		htmlContent = strip(htmlContent)
		return htmlContent
	end

end

