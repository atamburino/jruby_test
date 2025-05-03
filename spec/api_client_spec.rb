# This file contains RSpec tests for the ApiClient class.
# It verifies that the ApiClient can fetch and parse data from an API.

require 'rspec'
require_relative '../api_client'

RSpec.describe ApiClient do
  # Test case to verify that the fetch_data method retrieves and parses data correctly.
  it 'fetches data from the API' do
    client = ApiClient.new
    # Mock the Net::HTTP.get method to return a predefined JSON string.
    allow(Net::HTTP).to receive(:get).and_return('{"key": "value"}')

    # Call the fetch_data method and store the result.
    data = client.fetch_data

    # Expect the parsed data to match the predefined key-value pair.
    expect(data).to eq('key' => 'value')
  end
end 