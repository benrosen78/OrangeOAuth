Pod::Spec.new do |s|

  s.name         = "OrangeOAuth"
  s.version      = "1.0.2"
  s.summary      = "Orangered's dead-simple drop-in Reddit OAuth library."
  s.homepage     = "https://github.com/contextapps/OrangeOAuth"
 
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author    = "Context"

  s.source       = { :git => "https://github.com/contextapps/OrangeOAuth.git", :tag => s.version }

  s.source_files  = "Classes/*.{h,m}"
  s.platform     = :ios, '7.0'

  s.requires_arc = true

  s.dependency '1PasswordExtension', '~> 1.2'
  s.resources = "Resources/*"
end
