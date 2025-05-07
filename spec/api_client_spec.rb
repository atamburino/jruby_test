# This file contains RSpec tests for the ApiClient class.
# It serves as both a practical test suite and an educational resource
# demonstrating various RSpec testing concepts and best practices.

require 'rspec'
require_relative '../api_client'

# =============================================================================
# EDUCATIONAL NOTE: Top-level describe block
# =============================================================================
# The top-level describe block groups all tests related to a specific class 
# or component. By convention, we use RSpec.describe with the class name.
# This helps organize tests and provides clear output when running the suite.
# =============================================================================
RSpec.describe ApiClient do
  # Subject is a convenient method for referring to the object under test
  # It can be called in examples with just 'subject' instead of creating a new instance
  # EDUCATIONAL NOTE: RSpec's subject provides a cleaner way to refer to the object being tested
  subject(:client) { described_class.new(endpoint) }
  
  # Let is used to define memoized helper methods that can be used in examples
  # EDUCATIONAL NOTE: 'let' is lazy-evaluated and cached within each example
  let(:endpoint) { 'https://api.example.com/data' }
  let(:valid_json_response) { '{"key": "value", "items": [1, 2, 3]}' }
  let(:invalid_json_response) { '{not valid json}' }
  
  # =============================================================================
  # EDUCATIONAL NOTE: Context blocks
  # =============================================================================
  # Context blocks group related examples and provide a way to describe
  # different scenarios or state for the subject under test. They make
  # tests more readable and organized.
  # =============================================================================
  
  # This context groups tests for the happy path when everything works correctly
  context 'when the API request is successful' do
    # =============================================================================
    # EDUCATIONAL NOTE: Before blocks
    # =============================================================================
    # Before blocks run before each example in the context. They are used
    # to set up common state or stubs that are needed for the tests.
    # =============================================================================
    before do
      # Mock the Net::HTTP.get method to return a predefined JSON string
      # This is an example of stubbing external dependencies
      allow(Net::HTTP).to receive(:get).and_return(valid_json_response)
    end

    # EDUCATIONAL NOTE: Basic example with expectations
    it 'fetches and parses the data correctly' do
      # Call the method under test
      data = client.fetch_data
      
      # =============================================================================
      # EDUCATIONAL NOTE: Expectations and matchers
      # =============================================================================
      # Expectations verify that your code behaves as expected
      # RSpec provides many matchers for different types of assertions
      # =============================================================================
      
      # Basic equality matcher
      expect(data['key']).to eq('value')
      
      # Different types of matchers demonstration
      expect(data).to be_a(Hash)              # Type checking matcher
      expect(data).to include('key')          # Hash inclusion matcher
      expect(data['items']).to contain_exactly(1, 2, 3) # Array exact content matcher
      expect(data.keys).to match_array(['key', 'items']) # Array content matcher (order-independent)
    end
    
    # EDUCATIONAL NOTE: More specific test for the array response
    it 'correctly handles arrays in the JSON response' do
      data = client.fetch_data
      
      # Array specific expectations
      expect(data['items']).to be_an(Array)
      expect(data['items'].length).to eq(3)
      expect(data['items'].first).to eq(1)
    end
  end
  
  # This context groups tests related to error handling for JSON parsing issues
  context 'when the API returns invalid JSON' do
    before do
      allow(Net::HTTP).to receive(:get).and_return(invalid_json_response)
    end
    
    # =============================================================================
    # EDUCATIONAL NOTE: Testing exceptions
    # =============================================================================
    # RSpec provides ways to test that code raises specific exceptions
    # This is important for verifying error handling behavior
    # =============================================================================
    it 'raises a ParseError' do
      # The raise_error matcher verifies that the block raises the specified error
      expect { client.fetch_data }.to raise_error(ApiClientErrors::ParseError)
    end
    
    # More specific exception testing
    it 'includes details about the parsing error in the exception message' do
      # Chain matchers for more specific assertions
      expect { client.fetch_data }.to raise_error(ApiClientErrors::ParseError)
        .with_message(/Failed to parse JSON response/)
    end
  end
  
  # This context tests network error handling
  context 'when a network error occurs' do
    before do
      # Setup to simulate a network error
      allow(Net::HTTP).to receive(:get).and_raise(SocketError.new('Failed to connect'))
    end
    
    it 'raises a NetworkError' do
      expect { client.fetch_data }.to raise_error(ApiClientErrors::NetworkError)
    end
    
    it 'includes the original error message' do
      expect { client.fetch_data }.to raise_error(ApiClientErrors::NetworkError)
        .with_message(/Network error occurred: Failed to connect/)
    end
  end
  
  # This context demonstrates testing with different initialization parameters
  context 'when initialized with a custom endpoint' do
    let(:custom_endpoint) { 'https://api.custom.com/data' }
    subject(:custom_client) { described_class.new(custom_endpoint) }
    
    before do
      # Expect that Net::HTTP.get will be called with a URI containing our custom endpoint
      # This is an example of setting expectations on how methods are called
      expect(Net::HTTP).to receive(:get) do |uri|
        expect(uri.to_s).to eq(custom_endpoint)
        valid_json_response
      end
    end
    
    it 'uses the custom endpoint for the request' do
      # Just calling the method should trigger our expectation above
      custom_client.fetch_data
      # No need for additional assertions since they're in the before block
    end
  end
  
  # =============================================================================
  # EDUCATIONAL NOTE: Shared examples
  # =============================================================================
  # Shared examples allow you to reuse tests across multiple contexts
  # This is useful when different scenarios should exhibit the same behavior
  # =============================================================================
  shared_examples 'a successful API request' do |expected_data|
    it 'returns the expected data structure' do
      result = client.fetch_data
      expect(result).to eq(expected_data)
    end
  end
  
  # Using shared examples with different data scenarios
  context 'with a simple response' do
    let(:simple_response) { '{"status": "ok"}' }
    
    before do
      allow(Net::HTTP).to receive(:get).and_return(simple_response)
    end
    
    # Reusing the shared example
    it_behaves_like 'a successful API request', {'status' => 'ok'}
  end
  
  context 'with a complex response' do
    let(:complex_response) { '{"data": {"nested": {"value": 42}}, "status": "ok"}' }
    
    before do
      allow(Net::HTTP).to receive(:get).and_return(complex_response)
    end
    
    # Reusing the shared example with different data
    it_behaves_like 'a successful API request', {'data' => {'nested' => {'value' => 42}}, 'status' => 'ok'}
    
    # Additional specific test for complex data
    it 'allows accessing nested values' do
      result = client.fetch_data
      expect(result.dig('data', 'nested', 'value')).to eq(42)
    end
  end
end
