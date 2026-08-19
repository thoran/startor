require_relative './lib/Startor/VERSION'

class Gem::Specification
  def dependencies=(gems)
    gems.each{|gem| add_dependency(*gem)}
  end
end

Gem::Specification.new do |spec|
  spec.name = 'startor'
  spec.version = Startor::VERSION

  spec.summary = "tor management made easy."
  spec.description = "Easily install, start, and stop tor."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/startor'
  spec.license = 'MIT'

  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.7'
  spec.executables << 'startor'

  spec.metadata = {
    'tor_website' => "https://www.torproject.org",
    'tor_check_page' => "https://check.torproject.org",
  }

  spec.files = [
    Dir['bin/startor'],
    Dir['lib/**/*.rb'],
    'CHANGELOG',
  ].flatten

  spec.dependencies = %w{
    ostruct
  }
end
