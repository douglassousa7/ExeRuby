require 'net/http'

uri = URI('http://www.example.com')
response = Net::HTTP.get(uri)
puts response
