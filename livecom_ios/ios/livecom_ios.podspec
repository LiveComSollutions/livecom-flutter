#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint livecom_ios.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
    s.name                    = 'livecom_ios'
    s.version                 = '1.1.1'

    s.summary                 = 'LiveCom SDK'
    s.homepage                = 'https://divid.io'
    s.author                  = { 'Sakhabaev Egor' => 'e.sakhabaev@thesollution.com' }
    s.license                 = { :type => "MIT", :text => "MIT License" }

    s.platform                = :ios
    s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*'

    s.ios.vendored_frameworks = 'Frameworks/LiveComSDK.xcframework'
    s.ios.deployment_target   = '12.0'
    s.static_framework        = true
    s.resource_bundles        = { 'LiveComSDKBundle' => ['Frameworks/Resources/LiveComSDKBundle.bundle/*.{nib,storyboardc,car,strings}'] }

    s.dependency 'Flutter'

    s.dependency 'SwiftNIO', '2.32.0'
    s.dependency 'SwiftNIOSSL', '2.14.0'
    s.dependency 'SwiftNIOExtras', '1.11.0'
    s.dependency 'SwiftNIOTransportServices', '1.12.0'
    s.dependency 'SwiftNIOHTTP2', '1.19.2'

    s.dependency 'Analytics', '4.1.6'
    s.dependency 'StripeApplePay', '22.8.4'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
