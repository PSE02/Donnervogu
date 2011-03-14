#!/usr/bin/ruby1.9.1

require 'zip/zip'
require 'zip/zipfilesystem'

def createNewZip
	zipPath = Dir.pwd + "/profile.zip"

   Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) {
   	|zipfile|
   	zipfile.get_output_stream("user.js") { |f| f.puts "Hallo this is 
	a first test creating zips with ruby!" }  
   }
end

def generateUserEntries
	#We have to read all the important stuff out of the client model!
end	
	
if __FILE__ == $0
	createNewZip
end




