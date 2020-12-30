Gem::Specification.new do |spec|
  spec.name = 'startor'
  spec.version = '0.6.4'
  spec.date = '2020-12-30'

  spec.summary = "tor management made easy."
  spec.description = "Easily install, start, and stop tor."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/startor'
  spec.metadata = {
    'tor_website' => "https://www.torproject.org",
    'tor_check_page' => "https://check.torproject.org",
  }
  spec.license = 'MIT'

  spec.executables << 'startor'
  spec.files = Dir['bin/startor'] + Dir['lib/**/*.rb']
  spec.has_rdoc = false
  spec.required_ruby_version = '>= 1.8.6'
end
