# frozen_string_literal: true

class ApplicationController < Sinatra::Base
  before do
    content_type :json
  end

  def json_params
    JSON.parse(request.body.read)
  rescue JSON::ParserError
    halt 400, { message: 'Invalid JSON' }.to_json
  end
end
