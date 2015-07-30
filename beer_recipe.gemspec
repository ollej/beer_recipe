$:.push File.expand_path("../lib", __FILE__)

require 'beer_recipe/version'

Gem::Specification.new do |s|
  s.name        = 'beer_recipe'
  s.version     = BeerRecipe::VERSION
  s.date        = '2015-06-15'
  s.summary     = 'Simple Beer XML recipe formatter.'
  s.authors     = ['Olle Johansson']
  s.email       = 'Olle@Johansson.com'
  s.files       = Dir['{bin,lib,template,locales}/**/*']
  s.homepage    =
    'https://github.com/ollej/beer_recipe'
  s.license     = 'MIT'
  s.executables << 'beer_recipe'

  s.add_dependency 'nrb-beerxml', '~> 0.1'
  s.add_dependency 'docopt', '~> 0.5'

  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'rake', '~> 10.4'
end
