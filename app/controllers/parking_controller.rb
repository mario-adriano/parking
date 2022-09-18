# frozen_string_literal: true

require_relative 'application_controller'
require_relative '../serializers/parking_serializer'

# rubocop:disable Style/Documentation
class ParkingController < ApplicationController
  post '/parking' do
    parking = Parking.new(json_params)

    if parking.valid?
      if parking.save!
        status 201
        ParkingSerializer.new(parking).to_json
      else
        status 422
        response_json('Error persisting data')
      end
    else
      status 400
      response_json(parking.errors)
    end
  rescue Mongoid::Errors::UnknownAttribute => e
    status 400
    response_json(e.message)
  end

  put '/parking/:plate/out' do |plate|
    parking_lots = Parking.where(plate: plate)
    if parking_lots.any?
      parking = parking_lots.last

      if parking
        if parking.paid
          parking.left = true
          parking.payment_data = Time.now
          parking.save

          status 200
          ParkingSerializer.new(parking).to_json
        else
          status 400
          response_json('Payment not made')
        end
      else
        status 404
        response_json('Not found')
      end
    end
  end

  put '/parking/:plate/pay' do |plate|
    parking_lots = Parking.where(plate: plate)
    if parking_lots.any?
      parking = parking_lots.last

      if parking
        if parking.paid
          status 400
          response_json('Payment already made')
        else
          parking.paid = true
          parking.save

          status 200
          ParkingSerializer.new(parking).to_json
        end
      else
        status 404
        response_json('Not found')
      end
    end
  end

  get '/parking/:plate' do |plate|
    @parking = Parking.where(plate: plate)
    @parking.map { |parking| ParkingSerializer.new(parking) }.to_json
  end

  private

  def response_json(message)
    response = {
      body: message
    }
    response.to_json
  end
end
