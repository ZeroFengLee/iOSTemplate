
require "fileutils"
require File.expand_path('../proj_creator', __FILE__)

class FileMigration
    
    @@src_base_dir = 'src/'
    @@dst_base_dir = "../"
    
    # directory path
    attr_reader :src_xcode_dir, :src_setting_dir, :src_script_dir, :src_unit_dir, :src_ui_dir
    attr_reader :dst_xcode_dir, :dst_setting_dir, :dst_script_dir, :dst_unit_dir, :dst_ui_dir
    
    def initialize
        @src_xcode_dir = "#{@@src_base_dir}xcode_files"
        @src_setting_dir = "#{@@src_base_dir}setting_files"
        @src_script_dir = "#{@@src_base_dir}script"
        @src_unit_dir = "#{@@src_base_dir}unittest_files"
        @src_ui_dir = "#{@@src_base_dir}uitest_files"
        
        @dst_xcode_dir = @@dst_base_dir + $projName
        @dst_setting_dir = @@dst_base_dir
        @dst_script_dir = @@dst_base_dir + 'script'
        @dst_unit_dir = @@dst_base_dir + $projName + 'Tests'
        @dst_ui_dir = @@dst_base_dir + $projName + 'UITests'
    end
    
    def migration
        xcode_file_mig
        unit_file_mig
        ui_file_mig
        setting_file_mig
        script_mig
        rename_files
    end
    
    # migrate xcode files
    def xcode_file_mig
        files = files_in_folder(src_xcode_dir)
        files.each { |file_name|
            _src = "#{src_xcode_dir}/#{file_name}"
            FileUtils.cp_r(_src, dst_xcode_dir) if !File.exist?(dst_xcode_dir + '/' + file_name)
        }
    end

    # migrate unit test files
    def unit_file_mig
        files = files_in_folder(src_unit_dir)
        files.each { |file_name|
            _src = "#{src_unit_dir}/#{file_name}"
            FileUtils.cp(_src, dst_unit_dir) if !File.exist?(dst_unit_dir + '/' + file_name)
        }
    end

    #migrate ui test files
    def ui_file_mig
        files = files_in_folder(src_ui_dir)
        files.each { |file_name|
            _src = "#{src_ui_dir}/#{file_name}"
            FileUtils.cp(_src, dst_ui_dir) if !File.exist?(dst_ui_dir + '/' + file_name)
        }
    end
    
    # migrate setting files
    def setting_file_mig
        files = files_in_folder(src_setting_dir)
        files.each { |file_name|
            _src = "#{@src_setting_dir}/#{file_name}"
            FileUtils.cp(_src, @@dst_base_dir) if !File.exist?(@@dst_base_dir + file_name)
        }
    end
    
    # migrate script files
    def script_mig
        FileUtils.cp_r(src_script_dir, @@dst_base_dir) if !File.directory?('script')
    end
    
    def files_in_folder(folder)
        files = Dir.entries(folder)
        files.delete('.')
        files.delete('..')
        files
    end

    def rename_files
        #rename gitignore's filename
        File.rename(@@dst_base_dir + 'gitignore', @@dst_base_dir + '.gitignore')
        File.rename(dst_unit_dir + '/' + '/Tests.swift' , dst_unit_dir + '/' + $projName + 'Tests.swift')
        File.rename(dst_ui_dir + '/' + 'UITests.swift' , dst_ui_dir + '/' + $projName + 'UITests.swift')
    end
end

