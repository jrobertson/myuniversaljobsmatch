Gem::Specification.new do |s|
  s.name = 'myuniversaljobsmatch'
  s.version = '0.1.7'
  s.summary = 'A web scraper which searches for job adverts on ' + 
      'jobsearch.direct.gov.uk'
  s.authors = ['James Robertson']
  s.files = Dir['lib/myuniversaljobsmatch.rb']
  s.add_runtime_dependency('dynarex', '~> 1.7', '>=1.7.30')
  s.add_runtime_dependency('nokorexi', '~> 0.3', '>=0.3.2')
  s.signing_key = '../privatekeys/myuniversaljobsmatch.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/myuniversaljobsmatch'
end
