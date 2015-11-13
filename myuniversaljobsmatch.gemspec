Gem::Specification.new do |s|
  s.name = 'myuniversaljobsmatch'
  s.version = '0.1.6'
  s.summary = 'A web scraper which searches for job adverts on jobsearch.direct.gov.uk'
  s.authors = ['James Robertson']
  s.files = Dir['lib/myuniversaljobsmatch.rb']
  s.add_runtime_dependency('dynarex', '~> 1.5', '>=1.5.41')
  s.add_runtime_dependency('nokorexi', '~> 0.3', '>=0.3.1')
  s.signing_key = '../privatekeys/myuniversaljobsmatch.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/myuniversaljobsmatch'
end
