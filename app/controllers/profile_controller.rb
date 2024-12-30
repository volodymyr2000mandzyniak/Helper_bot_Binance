class ProfileController < ApplicationController
  require 'httparty'
  require 'dotenv/load'
  require 'json'

  def index
    @account_info = fetch_account_info
    @total_usdt = calculate_total_usdt(@account_info)
    @balances_with_usdt = calculate_balances_with_usdt(@account_info)
  end

  private

  def fetch_account_info
    api_key = ENV['BINANCE_API_KEY']
    api_secret = ENV['BINANCE_API_SECRET']
    timestamp = Time.now.to_i * 1000
    params = {
      timestamp: timestamp
    }
    signature = OpenSSL::HMAC.hexdigest('SHA256', api_secret, params.to_query)
    headers = {
      'X-MBX-APIKEY' => api_key
    }
    response = HTTParty.get("https://api.binance.com/api/v3/account?#{params.to_query}&signature=#{signature}", headers: headers)
    response.parsed_response
  end

  def calculate_total_usdt(account_info)
    total_usdt = 0.0
    account_info['balances'].each do |balance|
      if balance['free'].to_f > 0
        price_in_usdt = fetch_price_in_usdt(balance['asset'])
        total_usdt += balance['free'].to_f * price_in_usdt
      end
    end
    total_usdt
  end

  def calculate_balances_with_usdt(account_info)
    account_info['balances'].map do |balance|
      if balance['free'].to_f > 0
        price_in_usdt = fetch_price_in_usdt(balance['asset'])
        balance.merge('usdt_value' => balance['free'].to_f * price_in_usdt)
      else
        balance
      end
    end
  end

  def fetch_price_in_usdt(asset)
    response = HTTParty.get("https://api.binance.com/api/v3/ticker/price?symbol=#{asset}USDT")
    response.parsed_response['price'].to_f
  rescue
    0.0
  end
end
