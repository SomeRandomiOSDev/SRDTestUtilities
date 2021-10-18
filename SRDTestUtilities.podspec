Pod::Spec.new do |s|
  
  s.name         = "SRDTestUtilities"
  s.version      = "0.1.0"
  s.summary      = "A collection of useful APIs for unit testing"
  s.description  = <<-DESC
                   A lightweight framework that provides a collection of APIs that are useful for unit testing.
                   DESC
  
  s.homepage     = "https://github.com/SomeRandomiOSDev/SRDTestUtilities"
  s.license      = "MIT"
  s.author       = { "Joe Newton" => "somerandomiosdev@gmail.com" }
  s.source       = { :git => "https://github.com/SomeRandomiOSDev/SRDTestUtilities.git", :tag => s.version.to_s }

  s.ios.deployment_target     = '9.0'
  s.macos.deployment_target   = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.dependency          'ReadWriteLock', '~> 1.0'
  s.source_files      = 'Sources/SRDTestUtilities/*.swift',
                        'Sources/SRDTestUtilitiesObjC/**/*.{h,m}'
  s.swift_versions    = ['5.0']
  s.cocoapods_version = '>= 1.7.3'
  s.framework         = 'XCTest'

  s.test_spec 'Tests' do |ts|
    ts.ios.deployment_target     = '9.0'
    ts.macos.deployment_target   = '10.10'
    ts.tvos.deployment_target    = '9.0'
    ts.watchos.deployment_target = '2.0'

    ts.source_files              = 'Tests/SRDTestUtilitiesObjCTests/*Tests.m',
                                   'Tests/SRDTestUtilitiesSwiftTests/*Tests.swift'
  end
  
end
