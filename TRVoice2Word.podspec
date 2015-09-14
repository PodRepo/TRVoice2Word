
Pod::Spec.new do |s|

  s.name         = "TRVoice2Word"
  s.version      = "0.0.1"
  s.summary      = "fork fro TRVoice2Word"

  s.description  = <<-DESC
                   A longer description of TRSECoreTextView in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://lijinchao.sinaapp.com"
  s.license      = "MIT"
  s.author             = { "ljc" => "lijinchao2007@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/PodRepo/TRVoice2Word.git", :tag => s.version }

  s.source_files  = "Classes/TRVoice2Word/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.private_header_files = "Classes/TRVoice2Word/IATConfig.h"
  # s.public_header_files = "Classes/**/*.h"

  s.vendored_frameworks = 'iflyMSC.framework'
  s.vendored_frameworks = "Classes/**/*.{framework}"

  s.frameworks        = "CoreTelephony", "SystemConfiguration", "AddressBook"
  s.library = 'z'
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


end
