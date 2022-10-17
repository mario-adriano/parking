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
    parking = Parking.where(plate: plate).last

    if parking.present?

      if parking.paid
        parking.out!

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

  put '/parking/:plate/pay' do |plate|
    parking = Parking.where(plate: plate).last

    if parking.present?

      if parking.paid
        status 400
        response_json('Payment already made')
      else
        parking.pay!

        status 200
        ParkingSerializer.new(parking).to_json
      end
    else
      status 404
      response_json('Not found')
    end
  end

  get '/parking/:plate' do |plate|
    @parking = Parking.where(plate: plate)
    if @parking.any?
      status 200
      @parking.map { |parking| ParkingSerializer.new(parking) }.to_json
    else
      status 404
      response_json('Not found')
    end
  end

  private

  def response_json(message)
    response = {
      body: message
    }
    response.to_json
  end
end
