require 'net/http'
require 'json'

class ApiClient
  def fetch_data
    uri = URI('https://api.example.com/data')
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end 