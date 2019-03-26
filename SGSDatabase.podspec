Pod::Spec.new do |s|
  s.name             = 'SGSDatabase'
  s.version          = '0.1.1'
  s.summary          = '键值对形式存储的数据库管理类'

  s.homepage         = 'https://github.com/CharlsPrince/SGSDatabase.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CharlsPrince' => '961629701@qq.com' }
  s.source           = { :git => 'https://github.com/CharlsPrince/SGSDatabase.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SGSDatabase/Classes/**/*.{h,m}'
  s.public_header_files = 'SGSDatabase/Classes/**/*.{h}'

  s.dependency 'FMDB', '~> 2.7.5'

end
