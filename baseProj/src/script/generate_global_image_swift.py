#!/usr/bin/python
#coding=utf-8

import os
from optparse import OptionParser

DEFAULT_TARGET_DIRECTORY = './PROJECTNAME/Assets.xcassets'
DEFAULT_FILE_POSTFIX = '.imageset'
DEFAULT_SWIFT_FILE = './PROJECTNAME/Resources/GlobalImage.swift'

def parse_options():
    parser = OptionParser()
    parser.add_option('-d', '--directory', dest='target_directory', default=DEFAULT_TARGET_DIRECTORY, help='Specify the xcassets directory')
    parser.add_option('-f', '--file', dest='output_file', default=DEFAULT_SWIFT_FILE, help='Specify the output swift file')
    parser.add_option('-p', '--postfix', dest='file_postfix', default=DEFAULT_FILE_POSTFIX, help='Specify the postfix of target files')

    (options, args) = parser.parse_args()
    print 'options: %s, args: %s' % (options, args)

    return options

def scan_target_files(directory, postfix):
    files_list = []
    for root, sub_dirs, files in os.walk(directory):
        for special_file in sub_dirs:
            if special_file.endswith(postfix):
                files_list.append(special_file)
        for special_file in files:
            if special_file.endswith(postfix):
                files_list.append(special_file)
    return files_list

def generate_variable_name(original_name):
    captialized_items = map(lambda item: item.capitalize(), original_name.split('_'))
    return reduce(lambda x,y: x + y, captialized_items)

def generate_swift_file(output_file, imageset_names):
    variable_lines = map(lambda imageset: '    case {0} = "{1}"\n'.format(generate_variable_name(imageset), imageset), imageset_names)

    with open(output_file, 'w+') as file:
        file.writelines(['//\n',
                         '//  GlobalImage.swift\n',
                         '//  PROJECTNAME\n',
                         '//\n',
                         '//  Created by script automatically.\n',
                         '//\n',
                         '\n',
                         'import Foundation\n\n',
                         'enum ImageName: String {\n'])
        file.writelines(variable_lines)
        file.write('}\n')
    print '{0} is created success.'.format(output_file)

def main():
    options = parse_options()
    target_directory = options.target_directory
    output_file = options.output_file
    file_postfix = options.file_postfix

    imageset_names = map(lambda item: item[:-len(file_postfix)], scan_target_files(target_directory, file_postfix))
    generate_swift_file(output_file, imageset_names)

if __name__ == '__main__':
    main()
