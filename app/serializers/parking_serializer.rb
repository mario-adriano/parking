# frozen_string_literal: true

class ParkingSerializer
  def initialize(parking)
    @parking = parking
  end

  def as_json(*)
    data = {
      id: @parking.id.to_s,
      time: time_diff(@parking.created_at, @parking.payment_data || Time.now),
      paid: @parking.paid,
      left: @parking.left
    }
    data[:errors] = @parking.errors if @parking.errors.any?
    data
  end

  private

  def time_diff(start_time, end_time)
    seconds_diff = (start_time - end_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60

    "#{minutes.to_s.rjust(2, '0')} minutes"
  end
end
