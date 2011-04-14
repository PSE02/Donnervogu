require 'test_helper'

# Tests for the fileCreator module
# Needs 3 emailaccounts in the fixtures called "hans", "juerg" and "max" - please don't delete them!
#
# Author::    Dominique Rahm
# License::   Distributes under the same terms as Ruby

class CSVImportTest < ActiveSupport::TestCase
  setup do
    @hans = emailaccounts(:hans)
    @juerg = emailaccounts(:juerg)
    @max = emailaccounts(:max)
  end
   
end
