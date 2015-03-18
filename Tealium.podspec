Pod::Spec.new do |spec|
  spec.name             = 'Tealium'
  spec.version          = '4.1.2'
  spec.platforms        = 'ios'
  spec.homepage         = 'https://github.com/Tealium/ios-library'
  spec.summary          = 'Tealium library for iOS'
  spec.source           = { :git => "git@github.com:dcordero/ios-library.git", :tag => spec.version }
  spec.preserve_paths   = 'TealiumFull/TealiumLibrary.framework'
  spec.source_files     = 'TealiumFull/TealiumLibrary.framework/Versions/A/Headers/*.h'
  spec.frameworks       = 'TealiumLibrary', 'SystemConfiguration', 'CoreGraphics', 'UIKit'
  spec.xcconfig         =  { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/Tealium/TealiumFull"' }
end
