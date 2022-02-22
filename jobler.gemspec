$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "jobler/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jobler"
  s.version     = Jobler::VERSION
  s.authors     = ["kaspernj"]
  s.email       = ["kaspernj@gmail.com"]
  s.homepage    = "https://www.github.com/kaspernj/jobler"
  s.summary     = "Generate pages or files in the background"
  s.description = "Generate pages or files in the background"
  s.license     = "MIT"
  s.required_ruby_version = ">= 2.7"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 6.0.0"
  s.add_development_dependency "appraisal"
end
