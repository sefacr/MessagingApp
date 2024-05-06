# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MessagingApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MessagingApp
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Storage'
pod 'Firebase/Firestore'

pod 'IQAudioRecorderController'
pod 'JSQMessagesViewController', '7.3.3'
pod 'IDMPhotoBrowser'
pod 'RNCryptor'
pod 'ProgressHUD'
pod 'MBProgressHUD'
pod 'ImagePicker', :git => 'https://github.com/hyperoslo/ImagePicker'


post_install do |installer|
  installer.pods_project.targets.each do |target|
     target.build_configurations.each do |config|
       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
     end
   end
  # ios deployment version
  installer.pods_project.targets.each do |target|
     target.build_configurations.each do |config|
	xconfig_path = config.base_configuration_reference.real_path
	xconfig = File.read(xconfig_path)
	xconfig_mod = xconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
	File.open(xconfig_path, "w") { |file| file << xconfig_mod}
     end
    end
  end

end


