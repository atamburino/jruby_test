require 'rspec'
require_relative '../api_client'

RSpec.describe ApiClient do
  it 'fetches data from the API' do
    client = ApiClient.new
    allow(Net::HTTP).to receive(:get).and_return('{"key": "value"}')

    data = client.fetch_data

    expect(data).to eq('key' => 'value')
  end
end 