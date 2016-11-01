
$LOAD_PATH << '.'
require 'sub_str.rb'
require File.expand_path('../proj_creator', __FILE__)

class ConfSubsitution

	Ori_ProjName = 'PROJECTNAME'

	def initialize
		podfile_path = "../Podfile"
		gitignore_path = "../.gitignore"
		unitfile_path = "../#{$projName}Tests/#{$projName}Tests.swift"
		uifile_path = "../#{$projName}UITests/#{$projName}UITests.swift"

		@renamePaths = [podfile_path, gitignore_path, unitfile_path, uifile_path]
	end

	def start
		@renamePaths.each { |path| 
			ProSubStr.proj_sub_str(path, Ori_ProjName, $projName)
		}
	end
end