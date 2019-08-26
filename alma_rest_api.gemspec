Gem::Specification.new do |s|
  s.name        = 'alma_rest_api'
  s.version     = '1.0.1'
  s.date        = '2019-08-26'
  s.summary     = "Utility client for calling Alma REST APIs"
  s.add_runtime_dependency "rest-client", ['~> 2.0', '>= 2.0.0']
  s.add_runtime_dependency "nokogiri", ['~> 1.8', '>= 1.8.0']
  s.description = <<-EOF
    This gem can be used as a wrapper for REST API calls
    for Ex Libris Alma. For examples and more details see
    the Gem homepage.
  EOF
  s.authors     = ["Josh Weisman"]
  s.email       = 'josh.weisman@exlibrisgroup.com'
  s.files       = ["lib/alma_rest_api.rb"]
  s.homepage    =
    'https://github.com/jweisman/almarestapi-ruby-lib'
  s.license       = 'MIT'
end