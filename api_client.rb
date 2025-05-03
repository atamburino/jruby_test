require 'net/http'
require 'json'

# This file defines the ApiClient class, which is responsible for fetching data from an external API.

# The ApiClient class provides a method to fetch and parse JSON data from a specified API endpoint.
class ApiClient
  # Fetches data from the API and returns it as a parsed JSON object.
  def fetch_data
    uri = URI('https://api.example.com/data')
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end 