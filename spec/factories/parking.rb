FactoryGirl.define do
  factory :valid_plate, class: Parking do
    plate { 'aAa-1234' }
  end

  factory :vehicle_did_not_leave, class: Parking do
    plate { 'aAa-1234' }
    paid { true }
    left { false }
  end

  factory :plate_without_payment, class: Parking do
    plate { 'aAa-1234' }
    paid { false }
  end
end