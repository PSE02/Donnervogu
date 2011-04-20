
module EmailaccountHelper
  include ApplicationHelper
  # Translate a template string to a concrete string
  # e.g.
  # instanciate_template("Hello :::NAME:::, pleased to meet you.", {:name => "Mr. Smith"})
  # becomes "Hello Mr. Smith, pleased to meet you""
  # Author:: Aaron Karper <akarper@students.unibe.ch>
  #
  module TemplateHelper
    def instanciate_template template, dict
      template.gsub(/:::(.*?):::/) { dict[$1.downcase.to_sym].to_s }
    end

    # Normalizes a dictionary for the use in the templating system.
    # Use:: make_dict :name => "Mr. Smith"
    # Use:: make_dict {:name => "Mr. Smith"}
    def make_dict dict={}, *optional
      dict = optional unless optional.nil?
      newDict = {}
      dict.each_key do |key|
        newkey = key.to_s.downcase.to_sym
        newDict[newkey] = dict[key]
      end
      newDict
    end
  end
end
