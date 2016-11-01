
require "xcodeproj"
require "fileutils"

# project's name
$projName = ''

class ProCreator

	# default user's folder
	MainFolders = ['View', 'Model', 
				'ViewModel', 'Controller', 
				'Extension', 'Resources', 
				'DataBase', 'net']

	# program's base build settings
	@@mainSettings = {:'IPHONEOS_DEPLOYMENT_TARGET' => '8.0',
					:'SWIFT_VERSION' => '3.0'
				}
	@@unitTestSettings = @@mainSettings.clone
	@@uiTestSettings = @@mainSettings.clone

	# program's root dir
	@@filepath = '../'

	def initialize
		puts "\033[35m↓ ↓ ↓ ↓ ↓ Please Input Program\'s Name ↓ ↓ ↓ ↓ ↓\033[0m\n"

		$projName = gets.chomp

		@@mainSettings[:'PRODUCT_BUNDLE_IDENTIFIER'] = "com.oudmon.#{$projName}"
		@@mainSettings[:'INFOPLIST_FILE'] = "$(SRCROOT)/#{$projName}/Info.plist"

		@@unitTestSettings[:'PRODUCT_BUNDLE_IDENTIFIER'] = "com.oudmon.#{$projName}Tests"
		@@unitTestSettings[:'INFOPLIST_FILE'] = "$(SRCROOT)/#{$projName}Tests/Info.plist"

		@@uiTestSettings[:'PRODUCT_BUNDLE_IDENTIFIER'] = "com.oudmon.#{$projName}UITests"
		@@uiTestSettings[:'INFOPLIST_FILE'] = "$(SRCROOT)/#{$projName}UITests/Info.plist"
		@@uiTestSettings[:'LD_RUNPATH_SEARCH_PATHS'] = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks"
		@@uiTestSettings[:'IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'

		@proj
	end

	def start
		create_proj
		main_group = create_main_group
		creat_folders(main_group, $projName, MainFolders)
		create_unittest_group
		create_uitest_group
		save
	end

	private
	def create_proj
		# create a new default project
		projPath = "../#{$projName}.xcodeproj"
		Xcodeproj::Project.new(projPath).save
		# open proj befor edit
		@proj = Xcodeproj::Project.open(projPath)
	end

	def create_main_group
		# create folder 
		dst = @@filepath + $projName
		FileUtils.mkdir(dst) if !File.directory?(dst)

		mainGroup 	= @proj.main_group.new_group($projName, "./#{$projName}")
		ref1 		= mainGroup.new_reference('AppDelegate.swift')
		ref2 		= mainGroup.new_reference('Assets.xcassets')
		ref3 		= mainGroup.new_reference('Base.lproj/LaunchScreen.storyboard')
		ref4 		= mainGroup.new_reference('Base.lproj/Main.storyboard')
		_ 			= mainGroup.new_reference('Info.plist')

		target = @proj.new_target(:application, $projName, :ios)
		# Build Settings
		conf_target_settings(target, @@mainSettings)
		# add file to [Build Phases -> Compile Sources] 
		target.add_file_references([ref1])
		# add resources to [Build Phases -> Copy Bundle Resources]
		target.add_resources([ref2, ref3, ref4])
		mainGroup
	end

	def create_unittest_group
		# create unit test folder
		unit_dst = @@filepath + $projName + 'Tests'
		FileUtils.mkdir(unit_dst) if !File.directory?(unit_dst)

		unitTestName = "#{$projName}Tests"
		unitTestGroup = @proj.main_group.new_group(unitTestName, "./#{unitTestName}")
		ref = unitTestGroup.new_reference("#{unitTestName}.swift")
		_ = unitTestGroup.new_reference('Info.plist')

		target = @proj.new_target(:unit_test_bundle, "#{$projName}Tests", :ios)
		conf_target_settings(target, @@unitTestSettings)
		target.add_file_references([ref])
		target
	end

	def create_uitest_group
		# create ui test folder
		ui_dst = @@filepath + $projName + 'UITests'
		FileUtils.mkdir(ui_dst) if !File.directory?(ui_dst)

		uiTestName = "#{$projName}UITests"
		uiTestGroup = @proj.main_group.new_group(uiTestName, "./#{uiTestName}")
		ref = uiTestGroup.new_reference("#{uiTestName}.swift")
		_ = uiTestGroup.new_reference('Info.plist')

		target = @proj.new_target(:ui_test_bundle, "#{$projName}UITests", :ios)
		conf_target_settings(target, @@uiTestSettings)
		target.add_file_references([ref])
		target
	end

	def conf_target_settings(target, settings)
		settings.each { |key, value|
			target.build_configuration_list.set_setting(key, value)
		}
	end

	def creat_folders(group, group_name, folders)
		folders.each { |folder_name|
			folder_path = @@filepath + group_name + '/' + folder_name
			FileUtils.mkdir(folder_path) if !File.directory?(folder_path)
			group.new_group(folder_name)
		}
	end

	def save
		@proj.save
	end
end
