Gem::Specification.new do |s|
  s.name = 'myuniversaljobsmatch'
  s.version = '0.2.1'
  s.summary = 'A web scraper which searches for job adverts on ' + 
      'findajob.dwp.gov.uk'
  s.authors = ['James Robertson']
  s.files = Dir['lib/myuniversaljobsmatch.rb']
  s.add_runtime_dependency('chronic', '~> 0.10', '>=0.10.2')
  s.add_runtime_dependency('dynarex', '~> 1.8', '>=1.8.21')
  s.add_runtime_dependency('nokorexi', '~> 0.5', '>=0.5.0')
  s.signing_key = '../privatekeys/myuniversaljobsmatch.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/myuniversaljobsmatch'
end
