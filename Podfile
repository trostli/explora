platform :ios, "9.0"
use_frameworks!

target 'Explora' do
	pod 'AFNetworking', '~> 2.6.0'
	pod 'MBProgressHUD', '~> 0.9.1'
  pod 'Parse'
  pod 'Mapbox-iOS-SDK'
end

# disable bitcode in every sub-target for Mapbox
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end