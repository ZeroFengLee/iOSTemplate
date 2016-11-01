#!/usr/bin/python
#coding=utf-8

import os
from optparse import OptionParser
from ios_builder import iOSBuilder
from pgyer_uploader import uploadIpaToPgyer
from pgyer_uploader import saveQRCodeImage

#configuration for iOS build setting
BUILD_METHOND = 'xctool' # "xcodebuild"
WORKSPACE = 'PROJECTNAME.xcworkspace'
SCHEME = 'PROJECTNAME'
SDK = 'iphoneos' # "iphonesimulator"
BUILD_VERSION = '0.0.1'
CONFIGURATION = 'Release' # "Debug"
PROVISIONING_PROFILE = 'oudmon band wild develop'
OUTPUT_FOLDER = 'Build'

def parseOptions():
    parser = OptionParser()
    parser.add_option('-m', '--build_method', dest="build_method", default=BUILD_METHOND, help="Specify build method, xctool or xcodebuild")
    parser.add_option("-w", "--workspace", dest="workspace", default=WORKSPACE, help="Build the workspace name.xcworkspace")
    parser.add_option("-s", "--scheme", dest="scheme", default=SCHEME, help="Build the scheme specified by schemename. Required if building a workspace")
    parser.add_option("-p", "--project", dest="project", help="Build the project name.xcodeproj")
    parser.add_option("-t", "--target", dest="target", help="Build the target specified by targetname. Required if building a project")
    parser.add_option("-k", "--sdk", dest="sdk", default=SDK, help="Specify build SDK")
    parser.add_option("-v", "--build_version", dest="build_version", help="Specify build version number")
    parser.add_option("-r", "--provisioning_profile", dest="provisioning_profile", default=PROVISIONING_PROFILE, help="specify provisioning profile")
    parser.add_option("-l", "--plist_path", dest="plist_path", help="Specify build plist path")
    parser.add_option("-c", "--configuration", dest="configuration", default=CONFIGURATION, help="Specify build configuration. Default value is Release")
    parser.add_option("-o", "--output", dest="output", default=OUTPUT_FOLDER, help="specify output filename")
    parser.add_option("-d", "--update_description", dest="update_description", help="specify update description")

    (options, args) = parser.parse_args()
    print "options: %s, args: %s" % (options, args)
    return options

def main():
    options = parseOptions()

    build_method = options.build_method
    workspace = options.workspace
    scheme = options.scheme
    project = options.project
    target = options.target
    sdk = options.sdk
    build_version = options.build_version
    provisioning_profile = options.provisioning_profile
    plist_path = options.plist_path
    configuration = options.configuration
    output = options.output
    update_description = options.update_description

    if plist_path is None:
        plist_file_name = 'Info.plist'
        plist_path = os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, scheme, plist_file_name))

    ios_builder = iOSBuilder(
        build_method = build_method,
        workspace = workspace,
        scheme = scheme,
        project = project,
        target = target,
        sdk = sdk,
        configuration = configuration,
        build_version = build_version,
        provisioning_profile = provisioning_profile,
        plist_path = plist_path,
        output_folder = output
    )

    if sdk.startswith("iphoneos"):
        ipa_path = ios_builder.build_ipa()
        json_data = uploadIpaToPgyer(ipa_path, update_description)

        try:
            output_folder = os.path.dirname(ipa_path)
            saveQRCodeImage(json_data['appQRCodeURL'], output_folder)
        except Exception as e:
            print "Exception occured: %s" % str(e)
    elif sdk.startswith("iphonesimulator"):
        app_zip_path = ios_builder.build_app()


if __name__ == '__main__':
    main()
