# frozen_string_literal: true
require 'mongoid'

class Parking
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :plate, presence: true, format: { with: /\A[A-Za-z]{3}-[0-9]{4}\Z/i, message: "Invalid plate" }
  validates_uniqueness_of :plate, conditions: -> { where(left: false) }

  field :plate, type: String
  field :exit_time, type: Time
  field :paid, type: Boolean, default: false
  field :left, type: Boolean, default: false

  def out!
    @left = true
    @exit_time = Time.now
    save
  end

  def pay!
    @paid = true
    save
  end
end
