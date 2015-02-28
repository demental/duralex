$: << File.expand_path("../lib", __FILE__)

require "duralex/version"

Gem::Specification.new do |s|
  s.name        = "duralex"
  s.version     = Duralex::VERSION
  s.date        = "2015-02-28"
  s.summary     = "Helping in the process of terms acceptation."
  s.description = <<-DESC.gsub(/^\s+/, "")
  Helping in the process of terms acceptation.
  DESC
  s.authors     = ["Arnaud Sellenet"]
  s.email       = "arnodmental@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.homepage    = "https://github.com/demental/duralex"
  s.license     = "MIT"
end

