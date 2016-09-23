platform :ios,'8.0'
use_frameworks!
inhibit_all_warnings!

target 'MailBox' do
  pod 'SVProgressHUD', '2.0.3'
  pod 'mailcore2-ios', '0.6.4'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end