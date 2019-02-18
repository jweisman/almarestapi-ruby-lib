Gem::Specification.new do |s|
  s.name        = 'alma_rest_api'
  s.version     = '0.0.6'
  s.date        = '2019-02-17'
  s.summary     = "Utility client for calling Alma REST APIs"
  s.add_runtime_dependency "rest-client", ['~> 2.0', '>= 2.0.0']
  s.add_runtime_dependency "nokogiri", ['~> 1.8', '>= 1.8.0']
  s.description = ""
  s.authors     = ["Josh Weisman"]
  s.email       = 'josh.weisman@exlibrisgroup.com'
  s.files       = ["lib/alma_rest_api.rb"]
  s.homepage    =
    'https://github.com/jweisman/almarestapi-ruby-lib'
  s.license       = 'MIT'
end