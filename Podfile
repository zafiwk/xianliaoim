# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'xianliaoim' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!
  
  post_install do |installer|
         # 需要指定编译版本的第三方的名称
         myTargets = ['Alamofire']
      
       installer.pods_project.targets.each do |target|
         if myTargets.include? target.name
             target.build_configurations.each do |config|
                 config.build_settings['SWIFT_VERSION'] = '3.1'
             end
         end
      end
  end


  # Pods for xianliaoim
	pod 'Hyphenate'
	pod 'SDWebImage'
	pod 'TTTAttributedLabel'
	pod 'Masonry'
	pod 'XXNibBridge'
	pod 'AFNetworking'
	pod 'FLAnimatedImage'
	pod 'MBProgressHUD'
	pod 'Alamofire'
	pod 'Kingfisher'
	pod 'SnapKit'
	pod 'SVProgressHUD'
	pod 'FMDB'
	pod 'HandyJSON'
	pod 'MJRefresh'
    #短信
    pod 'mob_smssdk'
    pod 'FWPopupView'
end
