require 'net/http'
require 'json'
require 'rspec'

class Cce
  API_URL = "https://openexchangerates.org/api/latest.json?app_id=eedfab1685814cb09498824b18472e52"

  def initialize(currency, amount, to_currency)
    @currency = currency
    @amount = amount
    @to_currency = to_currency
    @exchange_rates = fetch_exchange_rates
  end

  def fetch_exchange_rates
    uri = URI(API_URL)
    response = Net::HTTP.get(uri)
    JSON.parse(response)["rates"]
  rescue StandardError => e
    puts "Error fetching exchange rates: #{e.message}"
    {}
  end

  def conver
    from_rate = @exchange_rates[@currency]
    to_rate = @exchange_rates[@to_currency]

    if from_rate.nil? || to_rate.nil?
      puts "Invalid currency code!"
      return
    end
    
      final=(@amount / from_rate) *to_rate
      puts "#{@amount} #{@currency} is #{final} #{@to_currency}"
  end
end

# puts "Welcome to the judiator"
# 25.times { print "-" }
# puts
# puts "CURRENCY EXCHANGE "

# print "Currency: "
# currency = gets.chomp.upcase
# print "Amount: "
# amount = gets.chomp.to_f
# print "To Currency: "
# to_currency = gets.chomp.upcase

# authentication = Cce.new(currency,amount,to_currency)
# authentication.conver

