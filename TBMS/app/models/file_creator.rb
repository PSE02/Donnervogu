require 'rubygems'
require 'hpricot'
require 'zip/zip' # rubyzip gem
require 'zip/zipfilesystem'

include StringstripperHelper

class FileCreator < ActiveRecord::Base
  #DR we have to refactor this to simple pass an array or a email (email would be even better!)
	def createNewZip html, quote, sig_style, signature
		zipPath = Dir.pwd + "/public/profiles/profile.zip"
		Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) do
			|zipfile|
			zipfile.get_output_stream("user.js") { |f| f.puts getConfig(html, quote, sig_style, signature)}  
		end
	end

	def getConfig html, quote, sig_style, signature
		filecontent = htmlTag(html)
		filecontent += quoteTag(quote)
		filecontent += sigTag(sig_style)
    filecontent += signaturTag(signature)
		return filecontent
	end

	#DR I love string interpolation! we don't need the XML anymore!
	#DR I think all this stuff will need some refactoring sooner or later!
	def htmlTag html
		htmlContent =  "/********************** HTML ***************************/ \n" +
		"// 0=ask, 1=plain, 2=html, 3=both \n" +
		"pref(\"mail.default_html_action\", #{html == "true" ? 2 : 1}); \n" +
	
	  "// true=Messages in HTML false=Messages not in HTML \n" +
    "user_pref(\"mail.identity.id1.compose_html\", #{html == "true"}); \n"
		return htmlContent
	end

   def quoteTag quote
     quoteContent = "\n/********************** Quotes *************************/ \n"+
     "// 0=reply below 1=reply above 2=select the quote \n" +
     "user_pref(\"mail.identity.id1.reply_on_top\", #{quote}); \n" +
     
     "// enable quoting for replies \n" +
     "user_pref(\"mail.identity.id1.auto_quote\", true); \n"
     return quoteContent
   end
   
  def sigTag sig_style
    sig_styleContent = "\n/********************** Signature Style*************************/ \n"+
    "// true=below the quote false=below my reply \n" +
    "user_pref(\"mail.identity.id1.sig_bottom\", #{sig_style == "true"}); \n" +
    "// add signatur to replies \n" +
    "user_pref(\"mail.identity.id1.sig_on_reply\", true); \n"
    return sig_styleContent
  end

  def signaturTag signature
    signaturContent = "\n/********************** Signature Text*************************/ \n" +
    "// true=allow html in signature false=don't allow html in signature \n" +
    "user_pref(\"mail.identity.id1.htmlSigFormat\", true); \n" +
    "// this is the part where the signature is saved if it's no file \n" +
    "user_pref(\"mail.identity.id1.htmlSigText\", \"#{signature}\"); \n"
    return signaturContent
  end
  
end

