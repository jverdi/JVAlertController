Pod::Spec.new do |s|
s.name         = "JVAlertController"
s.version      = "1.0.1"
s.summary      = "JVAlertController is an API-compatible backport of UIAlertController for iOS 7"
s.homepage     = "http://github.com/jverdi/JVAlertController"
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.author       = { "Jared Verdi" => "jared@jaredverdi.com" }
s.source       = { :git => "https://github.com/jverdi/JVAlertController.git", :tag => s.version.to_s }
s.platform     = :ios, '7.0'
s.source_files = 'JVAlertController/JVAlertController/*.{h,m}'
s.frameworks   = 'Foundation', 'UIKit'
s.requires_arc = true
end
