source 'git@INMBZP4112.in.dst.ibm.com:apple-coc-frameworks-private/cocoapod-specs.git'

inhibit_all_warnings!
use_frameworks!

def import_pods
    pod 'AKLogin'
    pod 'AKNetworking'
    pod 'AKLogger'
end

target 'ISS-Passes' do
  import_pods
end

target 'ISS-PassesTests' do
  import_pods
end

target 'ISS-PassesUITests' do
  import_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end