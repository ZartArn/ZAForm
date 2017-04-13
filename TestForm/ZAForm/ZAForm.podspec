Pod::Spec.new do |s|
  s.name = 'ZAForm'
  s.version = '0.0.4'
  s.summary = 'Form Manager'
  s.platform = :ios, '8.0'
  s.license = 'Code is MIT, then custom font licenses.'
  s.author = { "ZartArn" => "lewozart@gmail.com" }
  s.dependencies = {'ReactiveCocoa' => '~> 2.0', 'Masonry' => '~> 1.0'}
  s.homepage = 'http://spider.ru'
  s.source = {"path" => '~'}
  s.source_files = '**/*.{h,m}'
  s.requires_arc = true
end
