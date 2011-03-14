#!/usr/bin/ruby1.9.1

def createNewUserFile
	filepath = Dir.pwd + "/user.js"
	puts filepath
	aFile = File.open(filepath, 'w')
	aFile.puts("this is a test")
	aFile.close	
end
	
	
if __FILE__ == $0
	createNewUserFile
end
