Pod::Spec.new do |s|
  s.name             = 'SGSDatabase'
  s.version          = '0.1.0'
  s.summary          = '键值对形式存储的数据库管理类'

  s.homepage         = 'http://112.94.224.243:8081/kun.li/sgsdatabase/tree/master'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lee' => 'kun.li@southgis.com' }
  s.source           = { :git => 'http://112.94.224.243:8081/kun.li/sgsdatabase.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SGSDatabase/Classes/**/*.{h,m}'
  s.public_header_files = 'SGSDatabase/Classes/**/*.{h}'

  s.dependency 'FMDB', '~> 2.6.2'

end
