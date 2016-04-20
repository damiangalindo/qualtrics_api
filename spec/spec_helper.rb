require 'rspec'
require 'pry'
require 'qualtrics_api'
require 'coveralls'
Coveralls.wear!

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # config.mock_with :mocha
end