Pod::Spec.new do |s|
  s.name          = 'ZAForm'
  s.version       = '0.1.1'
  s.summary       = 'Form Manager'
  s.platform      = :ios, '8.0'
  s.license       = 'Code is MIT, then custom font licenses.'
  s.author        = { "ZartArn" => "lewozart@gmail.com" }
  s.homepage      = 'https://github.com/ZartArn'
  s.source        = {:git => 'https://github.com/ZartArn/ZAForm.git', :tag => 'v0.1.1'}
  s.source_files  = 'TestForm/ZAForm/**/*.{h,m}'
  s.requires_arc  = true
end
