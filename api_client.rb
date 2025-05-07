require 'net/http'
require 'json'

# This file defines the ApiClient class, which is responsible for fetching data from an external API.

# Custom exceptions for the ApiClient class
module ApiClientErrors
  # Base error class for all ApiClient errors
  class Error < StandardError; end
  
  # Raised when a network error occurs during an API request
  class NetworkError < Error; end
  
  # Raised when the API response cannot be parsed as JSON
  class ParseError < Error; end
  
  # Raised when the API returns an error response
  class ResponseError < Error
    attr_reader :code
    
    def initialize(message, code = nil)
      @code = code
      super(message)
    end
  end
end

# The ApiClient class provides a method to fetch and parse JSON data from a specified API endpoint.
class ApiClient
  # Default API endpoint
  DEFAULT_ENDPOINT = 'https://api.example.com/data'.freeze
  
  # Initialize a new ApiClient
  # @param endpoint [String] The API endpoint URL (optional)
  def initialize(endpoint = nil)
    @endpoint = endpoint || DEFAULT_ENDPOINT
  end
  
  # Fetches data from the API and returns it as a parsed JSON object.
  # @return [Hash, Array] Parsed JSON data from the API
  # @raise [ApiClientErrors::NetworkError] If a network error occurs
  # @raise [ApiClientErrors::ParseError] If the response isn't valid JSON
  # @raise [ApiClientErrors::ResponseError] If the API returns an error response
  def fetch_data
    uri = URI(@endpoint)
    response = fetch_from_api(uri)
    parse_json_response(response)
  end
  
  private
  
  # Fetches raw data from the API
  # @param uri [URI] The URI to fetch data from
  # @return [String] Raw response from the API
  # @raise [ApiClientErrors::NetworkError] If a network error occurs
  def fetch_from_api(uri)
    begin
      Net::HTTP.get(uri)
    rescue SocketError, Timeout::Error, Errno::ECONNREFUSED, Errno::EINVAL, Errno::ECONNRESET,
           EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise ApiClientErrors::NetworkError, "Network error occurred: #{e.message}"
    end
  end
  
  # Parses a JSON response string
  # @param response [String] JSON response string to parse
  # @return [Hash, Array] Parsed JSON data
  # @raise [ApiClientErrors::ParseError] If the response isn't valid JSON
  def parse_json_response(response)
    begin
      JSON.parse(response)
    rescue JSON::ParserError => e
      raise ApiClientErrors::ParseError, "Failed to parse JSON response: #{e.message}"
    end
  end
end
