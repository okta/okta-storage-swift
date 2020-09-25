Pod::Spec.new do |s|
  s.name             = 'OktaStorage'
  s.version          = '1.1.1'
  s.summary          = 'This library provides convenient APIs to utilize keychain services'
  s.description      = <<-DESC
Store passwords, tokens and other secrets in an encrypted database using OktaStorage library
                       DESC
  s.platforms    = { :ios => "9.0", :osx => "10.14"}
  s.homepage         = 'https://github.com/okta/okta-storage-swift'
  s.license          = { :type => 'APACHE2', :file => 'LICENSE' }
  s.authors          = { "Okta Developers" => "developer@okta.com"}
  s.source           = { :git => 'https://github.com/okta/okta-storage-swift.git', :tag => s.version.to_s }
  s.swift_version = '4.2'
  s.osx.deployment_target = '10.14'
  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/*'
end
