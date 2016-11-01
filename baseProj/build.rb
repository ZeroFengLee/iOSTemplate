
require File.expand_path('../proj_creator', __FILE__)
require File.expand_path('../file_migration', __FILE__)
require File.expand_path('../conf_substitution', __FILE__)

# create program
puts "\033[32m'=============START============='\033[0m\n"
creator = ProCreator.new
creator.start

# migrate files
puts "\033[32m'files setting...'\033[0m\n"
mig = FileMigration.new
mig.migration

# replace key words
puts "\033[32m'content setting...'\033[0m\n"
subOp = ConfSubsitution.new
subOp.start  

puts "\033[32m'pod install...'\033[0m\n"
puts "\033[32m#{`pod install`}\033[0m\n"