require 'sinatra'
require 'sinatra/base'

class Server < Sinatra::Base
  get '/' do
    "Hello from sinatra! The time is #{ Time.now } on #{ `hostname` }!"
  end
end