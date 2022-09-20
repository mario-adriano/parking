require_relative '../spec_helper'

describe Parking do
  it 'should validate :plate with correct data' do
    parking2 = Parking.new(plate: 'aaa-1234')
    expect(parking2).to be_valid
  end

  it 'should not validate plate without data' do
    parking = Parking.new(plate: '')
    expect(parking).to_not be_valid
  end

  it 'should not validate :plate (aaaa-1234) with wrong data' do
    parking = Parking.new(plate: 'aaaa-1234')
    expect(parking).to_not be_valid
  end

  it 'should not validate :plate (aaa-12345) with wrong data' do
    parking = Parking.new(plate: 'aaa-12345')
    expect(parking).to_not be_valid
  end

  it 'should not validate :plate (####) with wrong data' do
    parking = Parking.new(plate: '####')
    expect(parking).to_not be_valid
  end
end
