# frozen_string_literal: true

require 'sinatra'
require 'sinatra/base'
require 'mongoid'
require 'pry'
require 'json'

require_relative 'app/controllers/parking_controller'

require_relative 'app/models/parking'

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'])

# rubocop:disable Style/Documentation
class Application < Sinatra::Base
  configure do
    use ParkingController
  end

  get '/' do
    content_type :json
    response = {
      body: 'welcome to Parking ABC'
    }
    response.to_json
  end
end
