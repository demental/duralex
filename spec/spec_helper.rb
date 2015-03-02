require 'rubygems'

require "duralex"

Dir["support/**/*.rb"].each { |f| require_relative f }


RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec
end
