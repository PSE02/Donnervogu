module BooleanHelper
   def Boolean(string)
       return true if string == true || string =~ /^true$/i
       return false if string == false || string.nil? || string =~ /^false$/i
       raise ArgumentError.new("invalid value for Boolean: \"#{string}\"")
   end
end
