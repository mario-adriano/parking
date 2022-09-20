ENV['RACK_ENV'] = 'test'

require 'sinatra'
require 'rspec'
require 'json'
require 'rack/test'
require 'mongoid-rspec'
require 'database_cleaner'
require 'mongoid'
require 'factory_girl'

require_relative '../application'
require_relative './factories/parking'


RSpec.configure do |config|
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  config.include RSpec::Matchers
  config.include Mongoid::Matchers

  def app
    Application.new
  end

  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:mongoid].start
  end

  config.after(:each) do
    DatabaseCleaner[:mongoid].clean
  end

  config.profile_examples = 5
end
