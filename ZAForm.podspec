Pod::Spec.new do |s|
  s.name            = 'ZAForm'
  s.version         = '0.2.0'
  s.summary         = 'Form Manager'
  s.platform        = :ios, '8.0'
  s.license         = 'Code is MIT, then custom font licenses.'
  s.author          = { "ZartArn" => "lewozart@gmail.com" }
  s.homepage        = 'https://github.com/ZartArn'
  s.source          = {:git => 'https://github.com/ZartArn/ZAForm.git'}
  s.requires_arc    = true
  s.default_subspec = "ReactiveCocoa"

  s.subspec "ReactiveCocoa" do |ss|
    ss.source_files    = 'TestForm/ZAForm/**/*.{h,m}'
    ss.dependency 'ReactiveCocoa', '~> 2.0'
    ss.dependency 'Masonry'
    ss.prefix_header_file = "ZAForm-prefix.pch"
  end

  s.subspec "ReactiveObjC" do |ss|
    ss.source_files    = 'TestForm/ZAForm/**/*.{h,m}'
    ss.dependency 'ReactiveObjC'
    ss.dependency 'Masonry'
    ss.prefix_header_file = "ZAForm-ReactiveObjC-prefix.pch"
  end

end
