require_relative '../spec_helper'

describe 'POST /parking' do
  it 'should NOT register plate without parameters' do
    post '/parking', {}.to_json
    expect(last_response.status).to eq(400)
  end

  it 'should NOT register plate with empty parameters' do
    post '/parking', { plate: '' }.to_json
    expect(last_response.status).to eq(400)
  end

  it 'should NOT register plate with wrong key' do
    post '/parking', { plat: 'aaa-1234' }.to_json
    expect(last_response.status).to eq(400)
  end

  it 'should NOT register the same plate with no output' do
    post '/parking', { plate: 'aaa-1234' }.to_json
    post '/parking', { plate: 'aaa-1234' }.to_json
    expect(last_response.status).to eq(400)
  end

  it 'should register plate' do
    post "/parking", { plate: 'aaa-1234' }.to_json
    expect(last_response.status).to eq(201)
  end
end

describe 'PUT /parking/:plate/out' do
  let(:paid_vehicle) { create(:vehicle_did_not_leave) }
  let(:unpaid_vehicle) { create(:plate_without_payment) }

  it 'should NOT release plate without payment' do
    unpaid_vehicle.save!
    put "/parking/#{unpaid_vehicle.plate}/out", {}
    expect(last_response.status).to eq(400)
  end

  it 'should release plate with payment' do
    paid_vehicle.save!
    put "/parking/#{paid_vehicle.plate}/out", {}
    expect(last_response.status).to eq(200)
  end

  it 'should return 404 error for non-existing card' do
    put '/parking/ddd-1234/out', {}
    expect(last_response.status).to eq(404)
  end
end

describe 'PUT /parking/:plate/pay' do
  let(:paid_vehicle) { create(:vehicle_did_not_leave) }
  let(:unpaid_vehicle) { create(:plate_without_payment) }

  it 'should NOT release plate with payment' do
    paid_vehicle.save!
    put "/parking/#{paid_vehicle.plate}/pay", {}
    expect(last_response.status).to eq(400)
  end

  it 'should return 404 error for non-existing plate' do
    put '/parking/ddd-1234/pay', {}
    expect(last_response.status).to eq(404)
  end

  it 'should be able to pay without payment' do
    unpaid_vehicle.save!
    put "/parking/#{unpaid_vehicle.plate}/pay", {}
    expect(last_response.status).to eq(200)
  end
end

describe 'GET /parking/:plate' do
  let(:valid_plate) { create(:valid_plate) }

  it 'should return 200 for registered plate' do
    valid_plate.save!
    get "/parking/#{valid_plate.plate}", {}
    expect(last_response.status).to eq(200)
  end

  it 'should return error 404 for not exist for registered plate' do
    valid_plate.save!
    get '/parking/ddd-1234', {}
    expect(last_response.status).to eq(404)
  end
end